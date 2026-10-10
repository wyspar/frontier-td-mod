#!/usr/bin/perl
# Generates waves 1-300 of one difficulty's wave table in scripts/maps/map1-waves.lua
# (map1.lua uses them as map1.mapEasyWaves = mapWaveData.easyWaves and so on).
#
# Usage (from the mod folder, Git Bash):
#   perl tools/generate-map1-waves.pl normal           -> rewrites mapWaveData.normalWaves in map1-waves.lua
#   perl tools/generate-map1-waves.pl easy             -> rewrites mapWaveData.easyWaves
#   perl tools/generate-map1-waves.pl hard             -> rewrites mapWaveData.hardWaves
#   perl tools/generate-map1-waves.pl normal --print   -> only prints the table, does not touch map1-waves.lua
#
# The whole "mapWaveData.<difficulty>Waves = ..." statement is replaced (a one line alias like
# "mapWaveData.normalWaves = mapWaveData.easyWaves" or a full table ending with a "}" line),
# everything else in the file is left alone. Hand edits inside the table are lost, so change this script instead.
#
# Every group is either:
#   a stream: interval 1, startDelay 0, count = waveDuration * rate  -> spawns exactly count
#   a burst:  interval 0                                              -> whole count spawns at startDelay
# so count is always what really spawns (see processWave in control.lua).
# streams need count >= waveDuration (rate >= 1) or processWave never spawns them,
# so a stream that gets scaled below 1 per second is turned into evenly spread bursts instead.
#
# Enemy health scaling: control.lua divides the damage enemies take by 1 + growth * wave
# (ENEMY_HEALTH_GROWTH_PER_WAVE), so every enemy is that many times tankier.
# To keep that from stacking with the count ramp, counts are divided by the same multiplier
# and then multiplied by the difficulty's countFactor. The effective hp of a wave is then
# about countFactor times the unscaled base curve below, the difficulties differ by countFactor
# and by having fewer but tankier (hard) or more but weaker (easy) enemies.
# Bosses are never scaled, there is always exactly one.
use strict;
use warnings;

my $MAP_FILE = "scripts/maps/map1-waves.lua";
# the wave tables are fields of this table in $MAP_FILE (mapWaveData.easyWaves, ...)
my $TABLE_PREFIX = "mapWaveData";
my $FIRST_WAVE = 1;
my $LAST_WAVE = 300;
my $BOSS_WAVE_DURATION = 150;

# wave 1 (every difficulty): one small biter at 10 seconds, then the rest of the wave starts 25 seconds later
my $FIRST_WAVE_DURATION = 55;
my $FIRST_BITER_SECOND = 10;
my $FIRST_WAVE_REST_DELAY = 25;

# keep healthGrowth in sync with ENEMY_HEALTH_GROWTH_PER_WAVE in control.lua
my %DIFFICULTIES = (
  easy   => {tableName => "easyWaves",      label => "Easy",  healthGrowth => 0.02, countFactor => 0.8,  firstMediumWave => 7},
  normal => {tableName => "normalWaves",    label => "Normal", healthGrowth => 0.04, countFactor => 1.3,  firstMediumWave => 6},
  hard   => {tableName => "hardWaves",      label => "Hard",   healthGrowth => 0.06, countFactor => 1.75, firstMediumWave => 3},
);

# one boss every 50 waves, boss 2 is the ultra-flyer
my %BOSSES = (
  50  => "boss-biter-1",
  100 => "ultra-flyer",
  150 => "boss-biter-3",
  200 => "boss-biter-4",
  250 => "boss-biter-5",
  300 => "boss-biter-6",
);

my $printOnly = grep { $_ eq "--print" } @ARGV;
my ($difficultyName) = grep { $_ ne "--print" } @ARGV;
die "Usage: perl tools/generate-map1-waves.pl <easy|normal|hard> [--print]\n"
  unless defined $difficultyName && $DIFFICULTIES{lc $difficultyName};
my $difficulty = $DIFFICULTIES{lc $difficultyName};

# set per wave in buildWave, used by stream/bursts/burstAt
my $countScale = 1;

sub floorInt { return int($_[0]); }
sub roundInt { return int($_[0] + 0.5); }
sub maxInt { return $_[0] > $_[1] ? $_[0] : $_[1]; }
sub minInt { return $_[0] < $_[1] ? $_[0] : $_[1]; }

sub healthMultiplier {
  my ($wave) = @_;
  return 1 + $difficulty->{healthGrowth} * $wave;
}

sub isBossWave { my ($wave) = @_; return exists $BOSSES{$wave}; }

# boss waves take priority over flying waves (100, 200, 300)
sub isFlyingWave { my ($wave) = @_; return !isBossWave($wave) && $wave % 20 == 0; }

# 25 seconds for the first waves, then 30-60 seconds varied per wave. boss waves are always $BOSS_WAVE_DURATION
sub waveDuration {
  my ($wave) = @_;
  return $BOSS_WAVE_DURATION if isBossWave($wave);
  return $FIRST_WAVE_DURATION if $wave == 1;
  return 60 if $wave == 15;
  return 25 if $wave < 15;
  return 30 + (($wave * 17 + 7) % 31);
}

sub scaledCount { my ($count) = @_; return maxInt(1, roundInt($count * $countScale)); }

# `amount` bursts of `count` enemies, spread evenly through the wave (count is scaled)
sub bursts {
  my ($name, $amount, $count, $duration) = @_;
  # under 1 per burst: fewer bursts of 1 with about the same total, instead of rounding every burst up to 1
  my $exact = $count * $countScale;
  $amount = maxInt(1, roundInt($amount * $exact)) if $exact < 1;
  my $scaled = scaledCount($count);
  my @groups;
  for my $i (1 .. $amount) {
    push @groups, [$name, $scaled, 0, floorInt($duration * $i / ($amount + 1))];
  }
  return @groups;
}

# steady stream of `rate` enemies per second for the whole wave (rate is scaled)
# the total is kept exact: whole enemies per second go in a real stream, the leftover
# is sent one at a time spread evenly through the wave (no clumps, they would all walk in together)
sub stream {
  my ($name, $rate, $duration) = @_;
  my $total = maxInt(1, roundInt($duration * $rate * $countScale));
  my $perSecond = floorInt($total / $duration);
  my $leftover = $total - $perSecond * $duration;

  my @groups;
  push @groups, [$name, $perSecond * $duration, 1, 0] if $perSecond >= 1;
  for my $i (1 .. $leftover) {
    push @groups, [$name, 1, 0, floorInt($duration * ($i - 0.5) / $leftover)];
  }
  return @groups;
}

# `amount` small clusters of minSize..maxSize enemies mixed in through the wave.
# only the number of clusters is scaled, the cluster size is not, so "2-3 here and there" stays 2-3 on
# every difficulty. used instead of one big burst so a new or tougher enemy never arrives as a wall
sub clusters {
  my ($name, $amount, $minSize, $maxSize, $duration, $wave) = @_;
  my $n = maxInt(1, roundInt($amount * $countScale));
  my @groups;
  for my $i (1 .. $n) {
    my $size = $minSize + (($wave + $i) % ($maxSize - $minSize + 1));
    push @groups, [$name, $size, 0, floorInt($duration * ($i - 0.5) / $n)];
  }
  return @groups;
}

# one burst at a specific second (count is scaled)
sub burstAt {
  my ($name, $count, $second) = @_;
  return [$name, scaledCount($count), 0, $second];
}

# exactly `count`, never scaled (bosses)
sub unscaledAt {
  my ($name, $count, $second) = @_;
  return [$name, $count, 0, $second];
}

# only the boss, nothing else spawns during a boss wave
sub bossWave {
  my ($wave, $duration) = @_;
  my $boss = $BOSSES{$wave};
  return ("boss: $boss", unscaledAt($boss, 1, 5));
}

sub flyingWave {
  my ($wave, $duration) = @_;
  my @groups;

  if ($wave == 20) {
    push @groups, stream("small-flyer", 1, $duration);
  } elsif ($wave == 40) {
    push @groups, stream("small-flyer", 1, $duration);
    push @groups, bursts("medium-flyer", 3, 5, $duration);
  } elsif ($wave < 100) {
    # 60, 80: no small flyers after 50, behemoth flyers from 60
    # (60 is their first wave: fewer behemoths, an extra big flyer burst instead)
    push @groups, stream("medium-flyer", 1, $duration);
    push @groups, bursts("big-flyer", ($wave == 60 ? 4 : 3), ($wave == 60 ? 4 : 5), $duration);
    push @groups, bursts("behemoth-flyer", ($wave == 60 ? 1 : 3), ($wave == 60 ? 2 : 3), $duration);
  } else {
    # no medium flyers after 100
    my $s = $wave - 100;
    push @groups, stream("big-flyer", 1 + floorInt($s / 100), $duration);
    push @groups, bursts("big-flyer", 2 + floorInt($s / 50), 3 + floorInt($s / 40), $duration);
    push @groups, bursts("behemoth-flyer", 3 + floorInt($s / 50), 3 + floorInt($s / 30), $duration);
    push @groups, unscaledAt("ultra-flyer", 1 + floorInt(($wave - 220) / 40), floorInt($duration / 2)) if $wave >= 220;
  }

  return ("flying wave", @groups);
}

# 1-15: small biters, mediums from the difficulty's firstMediumWave, 15 is three big biters
sub earlyWave {
  my ($wave, $duration) = @_;
  my @groups;

  if ($wave == 15) {
    push @groups, bursts("big-biter", 3, 1, $duration);
    return ("", @groups);
  }

  # the early ramp follows the difficulty's first medium wave (easy 7, normal 6, hard 3):
  # small biters double 3 waves after it and a medium stream starts 6 waves after it.
  # mediums are mixed in as clusters (1-2 for the first 3 medium waves, then 2-3) instead of
  # one burst at the end of the wave, the big medium burst is saved for wave 21
  my $firstMedium = $difficulty->{firstMediumWave};
  push @groups, stream("small-biter", ($wave < $firstMedium + 3 ? 1 : 2), $duration);
  if ($wave >= $firstMedium) {
    my $minSize = $wave < $firstMedium + 3 ? 1 : 2;
    push @groups, clusters("medium-biter", 1 + floorInt(($wave - $firstMedium) / 5), $minSize, $minSize + 1, $duration, $wave);
  }
  push @groups, stream("medium-biter", 1, $duration) if $wave >= $firstMedium + 6;

  return ("", @groups);
}

# 16-29: medium biters ramp up, big biters from 22 (no regular biters after 29, 30-49 is spitters only)
# the medium stream gets clusters mixed in so it is not just a straight line:
# 2-3 mediums before wave 21, the big medium burst at the end of 21, then 4-5 mediums
sub biterWave {
  my ($wave, $duration) = @_;
  my @groups;

  push @groups, stream("medium-biter", 1, $duration);

  if ($wave < 21) {
    push @groups, clusters("medium-biter", 2 + floorInt(($wave - 16) / 2), 2, 3, $duration, $wave);
  } elsif ($wave == 21) {
    push @groups, burstAt("medium-biter", 6, $duration - 1);
  } else {
    push @groups, clusters("medium-biter", 2 + floorInt(($wave - 22) / 3), 4, 5, $duration, $wave);
  }

  if ($wave >= 22) {
    my $count = 1 + floorInt(($wave - 22) / 10);
    push @groups, bursts("big-biter", 1 + floorInt(($wave - 22) / 7), $count, $duration);
    # every wave ending in 5 gets an extra heavy push at the end. big biters are still new here,
    # so it is a cluster of mediums instead of a wall of bigs
    push @groups, burstAt("medium-biter", 5, $duration - 5) if $wave % 10 == 5;
  }

  return ("", @groups);
}

# enemy families after the regular biters, each has small/medium/big/behemoth
my %FAMILIES = (
  spitter   => {small => "small-spitter", medium => "medium-spitter", big => "big-spitter", behemoth => "behemoth-spitter"},
  physical  => {map { $_ => "$_-physical-biter" } qw(small medium big behemoth)},
  fire      => {map { $_ => "$_-fire-biter" } qw(small medium big behemoth)},
  laser     => {map { $_ => "$_-laser-biter" } qw(small medium big behemoth)},
  explosion => {map { $_ => "$_-explosion-biter" } qw(small medium big behemoth)},
);

# the 20 waves before these bosses only use one family (flying waves still take priority every 20 waves)
my @SPECIAL_WAVES = (
  {first => 30,  last => 49,  family => "spitter",   note => "special: spitters only"},
  {first => 80,  last => 99,  family => "fire",      note => "special: fire biters only"},
  {first => 130, last => 149, family => "laser",     note => "special: laser biters only"},
  {first => 180, last => 199, family => "explosion", note => "special: explosion biters only"},
);

# from this wave on the family is part of the mixed waves
# physical biters come in at 51, when the regular biters stop
my @FAMILY_UNLOCKS = (
  {wave => 30,  family => "spitter"},
  {wave => 51,  family => "physical"},
  {wave => 80,  family => "fire"},
  {wave => 130, family => "laser"},
  {wave => 180, family => "explosion"},
);

sub specialWaveFor {
  my ($wave) = @_;
  for my $special (@SPECIAL_WAVES) {
    return $special if $wave >= $special->{first} && $wave <= $special->{last};
  }
  return undef;
}

sub unlockedFamilies {
  my ($wave) = @_;
  return map { $_->{family} } grep { $_->{wave} <= $wave } @FAMILY_UNLOCKS;
}

sub familyUnlockWave {
  my ($family) = @_;
  my ($unlock) = grep { $_->{family} eq $family } @FAMILY_UNLOCKS;
  return $unlock->{wave};
}

# behemoths never come right away: not before $BEHEMOTH_WAVE and not in a family's first
# $BEHEMOTH_FAMILY_DELAY waves (spitter 56, physical 63, fire 92, laser 142, explosion 192).
# until then (and for a while after) the family gets extra big bursts instead
my $BEHEMOTH_WAVE = 56;
my $BEHEMOTH_FAMILY_DELAY = 12;
my $BEHEMOTH_RAMP_WAVES = 20;

sub behemothWave {
  my ($family) = @_;
  return maxInt($BEHEMOTH_WAVE, familyUnlockWave($family) + $BEHEMOTH_FAMILY_DELAY);
}

# which sizes can spawn: no small after 50, no medium biters after 100 (medium spitters stay),
# behemoths from the family's behemothWave
sub allowedSizes {
  my ($family, $wave) = @_;
  my @sizes;
  push @sizes, "small" if $wave < 50;
  push @sizes, "medium" if $wave <= 100 || $family eq "spitter";
  push @sizes, "big";
  push @sizes, "behemoth" if $wave >= behemothWave($family);
  return @sizes;
}

# base curve for one family: a stream of the smallest allowed size,
# bursts of every allowed size and a heavy burst at the end of waves ending in 5
sub familyGroups {
  my ($family, $wave, $duration) = @_;
  my $names = $FAMILIES{$family};
  my @sizes = allowedSizes($family, $wave);
  my $sinceBehemoth = $wave - behemothWave($family);
  my @groups;

  push @groups, stream($names->{$sizes[0]}, 1 + floorInt($wave / 60), $duration);

  for my $size (@sizes) {
    if ($size eq "small") {
      push @groups, bursts($names->{small}, 3, 3 + floorInt($wave / 10), $duration);
    } elsif ($size eq "medium") {
      push @groups, bursts($names->{medium}, 2 + floorInt($wave / 40), 2 + floorInt($wave / 25), $duration);
    } elsif ($size eq "big") {
      # extra big bursts: building up to 2 more in the family's first waves, 1 more for good once behemoths have settled in
      my $extra = $sinceBehemoth < $BEHEMOTH_RAMP_WAVES
        ? minInt(2, floorInt(($wave - familyUnlockWave($family)) / 6))
        : 1;
      push @groups, bursts($names->{big}, 1 + floorInt($wave / 40) + $extra, 1 + floorInt($wave / 30), $duration);
    } else {
      # the first behemoths of a family come one at a time and ramp up to the full curve
      my $amount = minInt(1 + floorInt(($wave - 40) / 60), 1 + floorInt($sinceBehemoth / 10));
      my $count = minInt(1 + floorInt(($wave - 40) / 40), 1 + floorInt($sinceBehemoth / 6));
      push @groups, bursts($names->{behemoth}, $amount, $count, $duration);
    }
  }

  # the heavy burst uses big instead of behemoth while the family's behemoths are still new
  my $heavySize = ($sizes[-1] eq "behemoth" && $sinceBehemoth < $BEHEMOTH_RAMP_WAVES) ? "big" : $sizes[-1];
  push @groups, burstAt($names->{$heavySize}, 2 + floorInt($wave / 50), $duration - 5) if $wave % 10 == 5;

  return @groups;
}

# 30-49, 80-99, 130-149, 180-199: one family only
sub specialWave {
  my ($wave, $duration, $special) = @_;
  return ($special->{note}, familyGroups($special->{family}, $wave, $duration));
}

# every other wave from 51: a mix of every family unlocked so far (no regular biters, no bosses).
# each family gets an equal share of the counts so a mix is about as tough as a special wave
sub mixedWave {
  my ($wave, $duration) = @_;
  my @families = unlockedFamilies($wave);
  my $fullScale = $countScale;
  $countScale = $fullScale / scalar(@families);

  my @groups;
  push @groups, familyGroups($_, $wave, $duration) for @families;

  $countScale = $fullScale;
  return ("mix: " . join(", ", @families), @groups);
}

# wave 1: a single small biter first, then the normal wave 1 groups squeezed into the time that is left.
# streams can't start late (they spawn from the start of the wave), so they become evenly spread bursts
sub firstWave {
  my ($duration) = @_;
  my $restStart = $FIRST_BITER_SECOND + $FIRST_WAVE_REST_DELAY;
  my $restDuration = $duration - $restStart;
  my ($note, @rest) = earlyWave(1, $restDuration);

  my @groups = (unscaledAt("small-biter", 1, $FIRST_BITER_SECOND));
  for my $group (@rest) {
    my ($name, $count, $interval, $startDelay) = @$group;
    if ($interval == 0) {
      push @groups, [$name, $count, 0, $restStart + $startDelay];
      next;
    }
    # same rate as the stream, one burst per second
    my $perSecond = $count / $restDuration;
    for my $second (0 .. $restDuration - 1) {
      push @groups, [$name, $perSecond, 0, $restStart + $second];
    }
  }

  return ("first biter at $FIRST_BITER_SECOND, the rest from $restStart", @groups);
}

sub buildWave {
  my ($wave) = @_;
  my $duration = waveDuration($wave);
  $countScale = $difficulty->{countFactor} / healthMultiplier($wave);

  return ($duration, firstWave($duration)) if $wave == 1;
  return ($duration, bossWave($wave, $duration)) if isBossWave($wave);
  return ($duration, flyingWave($wave, $duration)) if isFlyingWave($wave);
  return ($duration, earlyWave($wave, $duration)) if $wave <= 15;
  return ($duration, biterWave($wave, $duration)) if $wave < 30;
  my $special = specialWaveFor($wave);
  return ($duration, specialWave($wave, $duration, $special)) if $special;
  return ($duration, mixedWave($wave, $duration));
}

sub generateWavesLua {
  my $tableName = $difficulty->{tableName};
  my $lua = "";
  $lua .= "$TABLE_PREFIX.$tableName = {\n";
  $lua .= "  -- GENERATED $difficulty->{label} waves (tools/generate-map1-waves.pl $difficultyName), edit the script and rerun it instead\n";
  $lua .= "  -- counts are divided by the enemy health multiplier (1 + $difficulty->{healthGrowth} * wave) and times $difficulty->{countFactor}\n";
  $lua .= "  -- 1-29 regular biters, special waves: 30-49 spitters, 80-99 fire, 130-149 laser, 180-199 explosion biters only\n";
  $lua .= "  -- every other wave from 51 mixes the families unlocked so far (spitter, physical from 51, then fire, laser, explosion)\n";
  $lua .= "  -- no regular biters after 50, no small biters/flyers after 50, no medium biters/flyers after 100\n";
  $lua .= "  -- early mediums come in clusters (2-3, then 4-5 after the wave 21 medium burst) instead of end of wave bursts\n";
  $lua .= "  -- behemoths from $BEHEMOTH_WAVE at the earliest and $BEHEMOTH_FAMILY_DELAY waves after a family unlocks, ramped in one at a time with extra bigs\n";
  $lua .= "  -- every 20 waves is a flying wave, every 50 waves is a $BOSS_WAVE_DURATION second boss wave (boss takes priority)\n";
  $lua .= "  -- groups are streams (interval 1, startDelay 0, count = waveDuration * rate) or bursts (interval 0)\n";
  $lua .= "  -- so count is exactly what spawns. /wave shows the real numbers either way\n";

  for my $wave ($FIRST_WAVE .. $LAST_WAVE) {
    my ($duration, $note, @groups) = buildWave($wave);
    my $comment = $note ? " -- $note" : "";

    $lua .= "  [$wave] = {$comment\n";
    $lua .= "    waveDuration = $duration,\n";
    $lua .= "    groups = {\n";
    for my $group (@groups) {
      my ($name, $count, $interval, $startDelay) = @$group;
      $lua .= "      {name = \"$name\", count = $count, interval = $interval, startDelay = $startDelay},\n";
    }
    $lua .= "    },\n";
    $lua .= "  },\n";
  }

  $lua .= "}\n";
  return $lua;
}

my $wavesLua = generateWavesLua();

if ($printOnly) {
  print $wavesLua;
  exit 0;
}

open my $in, "<", $MAP_FILE or die "Cannot open $MAP_FILE (run this from the mod folder): $!\n";
my @lines = <$in>;
close $in;

# keep whatever line endings map1-waves.lua already uses
my $eol = ($lines[0] =~ /\r\n$/) ? "\r\n" : "\n";
$wavesLua =~ s/\r?\n/$eol/g;

my $tableName = $difficulty->{tableName};
my ($start) = grep { $lines[$_] =~ /^\Q$TABLE_PREFIX\E\.\Q$tableName\E\s*=/ } 0 .. $#lines;
die "Could not find \"$TABLE_PREFIX.$tableName =\" in $MAP_FILE\n" unless defined $start;

# a full table runs to the next "}" at the start of a line, an alias is just the one line
my $end = $start;
if ($lines[$start] =~ /\{\s*$/) {
  ($end) = grep { $lines[$_] =~ /^\}\s*$/ } $start + 1 .. $#lines;
  die "Could not find the closing \"}\" of $TABLE_PREFIX.$tableName in $MAP_FILE\n" unless defined $end;
}

splice @lines, $start, $end - $start + 1, $wavesLua;

open my $out, ">", $MAP_FILE or die "Cannot write $MAP_FILE: $!\n";
print $out @lines;
close $out;

print "Wrote $difficulty->{label} waves $FIRST_WAVE-$LAST_WAVE to $TABLE_PREFIX.$tableName in $MAP_FILE\n";
