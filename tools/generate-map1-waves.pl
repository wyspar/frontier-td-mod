#!/usr/bin/perl
# Generates waves 16-300 of map1.mapNormalWaves in scripts/maps/map1.lua.
#
# Usage (from the mod folder, Git Bash):
#   perl tools/generate-map1-waves.pl            -> rewrites the waves inside map1.lua
#   perl tools/generate-map1-waves.pl --print    -> only prints the waves, does not touch map1.lua
#
# Only the lines between "-- BEGIN GENERATED WAVES" and "-- END GENERATED WAVES" in map1.lua
# are replaced, waves 1-15 and everything else in the file are left alone.
#
# Every group is either:
#   a stream: interval 1, startDelay 0, count = waveDuration * rate  -> spawns exactly count
#   a burst:  interval 0                                              -> whole count spawns at startDelay
# so count is always what really spawns (see processWave in control.lua).
use strict;
use warnings;

my $MAP_FILE = "scripts/maps/map1.lua";
my $FIRST_WAVE = 16;
my $LAST_WAVE = 300;

# 30-60 seconds, varied per wave. boss waves are always 60
sub waveDuration {
  my ($wave) = @_;
  return 60 if isBossWave($wave);
  return 30 + (($wave * 17 + 7) % 31);
}

sub isBossWave { my ($wave) = @_; return $wave % 50 == 0; }

# boss waves take priority over flying waves (100, 200, 300)
sub isFlyingWave { my ($wave) = @_; return !isBossWave($wave) && $wave % 20 == 0; }

sub floorInt { return int($_[0]); }

# steady stream of `rate` enemies per second for the whole wave
sub stream {
  my ($name, $rate, $duration) = @_;
  return [$name, $duration * $rate, 1, 0];
}

# `amount` bursts of `count` enemies, spread evenly through the wave
sub bursts {
  my ($name, $amount, $count, $duration) = @_;
  my @groups;
  for my $i (1 .. $amount) {
    push @groups, [$name, $count, 0, floorInt($duration * $i / ($amount + 1))];
  }
  return @groups;
}

# one burst at a specific second
sub burstAt {
  my ($name, $count, $second) = @_;
  return [$name, $count, 0, $second];
}

sub bossWave {
  my ($wave, $duration) = @_;

  if ($wave == 50) {
    return ("boss: first boss",
      burstAt("boss-biter-1", 1, 5),
      stream("medium-biter", 1, $duration));
  }

  if ($wave == 100) {
    return ("boss: ultra flyers",
      bursts("ultra-flyer", 3, 1, $duration));
  }

  # 150: 2, 200: 3, 250: 4, 300: 5 boss-biter-1
  my $bossCount = $wave / 50 - 1;
  return ("boss: placeholder, more than one boss-biter-1 (change later)",
    bursts("boss-biter-1", $bossCount, 1, $duration));
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
    push @groups, stream("medium-flyer", 1, $duration);
    push @groups, bursts("big-flyer", ($wave == 60 ? 2 : 3), ($wave == 60 ? 2 : 4), $duration);
  } else {
    my $s = $wave - 100;
    push @groups, stream("medium-flyer", 1 + floorInt($s / 100), $duration);
    push @groups, bursts("big-flyer", 2 + floorInt($s / 50), 2 + floorInt($s / 40), $duration);
    push @groups, bursts("behemoth-flyer", 1 + floorInt(($s - 40) / 60), 1 + floorInt(($s - 40) / 50), $duration) if $s >= 40;
    push @groups, burstAt("ultra-flyer", 1 + floorInt(($wave - 220) / 40), floorInt($duration / 2)) if $wave >= 220;
  }

  return ("flying wave", @groups);
}

# 16-49: medium biters ramp up, big biters from 22, behemoth biters from 42
sub biterWave {
  my ($wave, $duration) = @_;
  my @groups;

  push @groups, stream("medium-biter", ($wave < 32 ? 1 : 2), $duration);

  if ($wave >= 22) {
    my $count = 1 + floorInt(($wave - 22) / 10);
    push @groups, bursts("big-biter", 1 + floorInt(($wave - 22) / 7), $count, $duration);
    # every wave ending in 5 gets an extra heavy burst at the end
    push @groups, burstAt("big-biter", $count + 2, $duration - 5) if $wave % 10 == 5;
  }

  push @groups, burstAt("behemoth-biter", ($wave >= 46 ? 2 : 1), floorInt($duration * 2 / 3)) if $wave >= 42;

  return ("", @groups);
}

# 51-99: no more biters, medium spitters and up (they split into smaller spitters when killed)
sub spitterWave {
  my ($wave, $duration) = @_;
  my @groups;

  push @groups, stream("medium-spitter", ($wave < 70 ? 1 : 2), $duration);

  my $count = 1 + floorInt(($wave - 51) / 12);
  push @groups, bursts("big-spitter", 1 + floorInt(($wave - 51) / 8), $count, $duration);
  push @groups, burstAt("big-spitter", $count + 2, $duration - 5) if $wave % 10 == 5;

  push @groups, burstAt("behemoth-spitter", 1 + floorInt(($wave - 80) / 10), floorInt($duration * 2 / 3)) if $wave >= 80;

  return ("", @groups);
}

# 101-299: spitters plus physical biters
sub physicalWave {
  my ($wave, $duration) = @_;
  my $s = $wave - 100;
  my @groups;

  push @groups, stream("small-physical-biter", 1 + floorInt($s / 60), $duration);
  push @groups, stream("medium-spitter", 2 + floorInt($s / 100), $duration);
  push @groups, bursts("medium-physical-biter", 3 + floorInt($s / 40), 3 + floorInt($s / 25), $duration);
  push @groups, bursts("big-physical-biter", 2 + floorInt($s / 40), 2 + floorInt($s / 40), $duration);
  push @groups, bursts("big-spitter", 3 + floorInt($s / 50), 3 + floorInt($s / 50), $duration);
  push @groups, burstAt("behemoth-spitter", 2 + floorInt($s / 50), floorInt($duration / 2));
  push @groups, bursts("behemoth-physical-biter", 1 + floorInt(($s - 20) / 60), 1 + floorInt(($s - 20) / 40), $duration) if $s >= 20;
  push @groups, burstAt("behemoth-physical-biter", 1 + floorInt($s / 50), $duration - 5) if $wave % 10 == 5;

  return ("", @groups);
}

sub buildWave {
  my ($wave) = @_;
  my $duration = waveDuration($wave);

  return ($duration, bossWave($wave, $duration)) if isBossWave($wave);
  return ($duration, flyingWave($wave, $duration)) if isFlyingWave($wave);
  return ($duration, biterWave($wave, $duration)) if $wave < 50;
  return ($duration, spitterWave($wave, $duration)) if $wave < 100;
  return ($duration, physicalWave($wave, $duration));
}

sub generateWavesLua {
  my $lua = "";
  $lua .= "  -- waves 16-300: no small biters after 15, mediums -> bigs -> behemoths up to 49\n";
  $lua .= "  -- 50+ spitters (medium and up), 100+ physical biters added\n";
  $lua .= "  -- every 20 waves is a flying wave, every 50 waves is a boss wave (boss takes priority)\n";
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

  return $lua;
}

my $wavesLua = generateWavesLua();

if (@ARGV && $ARGV[0] eq "--print") {
  print $wavesLua;
  exit 0;
}

open my $in, "<", $MAP_FILE or die "Cannot open $MAP_FILE (run this from the mod folder): $!\n";
my @lines = <$in>;
close $in;

# keep whatever line endings map1.lua already uses
my $eol = ($lines[0] =~ /\r\n$/) ? "\r\n" : "\n";
$wavesLua =~ s/\r?\n/$eol/g;

my ($begin) = grep { $lines[$_] =~ /-- BEGIN GENERATED WAVES/ } 0 .. $#lines;
my ($end) = grep { $lines[$_] =~ /-- END GENERATED WAVES/ } 0 .. $#lines;
die "Could not find the BEGIN/END GENERATED WAVES markers in $MAP_FILE\n"
  unless defined $begin && defined $end && $begin < $end;

splice @lines, $begin + 1, $end - $begin - 1, $wavesLua;

open my $out, ">", $MAP_FILE or die "Cannot write $MAP_FILE: $!\n";
print $out @lines;
close $out;

print "Wrote waves $FIRST_WAVE-$LAST_WAVE to $MAP_FILE\n";
