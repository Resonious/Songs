# Welcome to Sonic Pi v3.1

treble_ch = [
  (chord :c4, :major),
  (chord :d4, :major),
  (chord :e4, :major)
]

bass_ch = [
  (chord :c2, :major),
  (chord :d2, :major),
  (chord :e2, :major)
]


define :main_melody_8 do
  # Chord pattern:
  #
  # 0 * 3
  # 1 * 4
  # 2 * 1

  ch = treble_ch[0]

  play ch[0]
  sleep 1

  play ch[0]
  sleep 1

  play ch[1]
  sleep 0.5
  play ch[2]
  sleep 0.5

  ch = treble_ch[1]

  play ch[2]
  sleep 1

  play ch[0]
  sleep 1

  play ch[1]
  sleep 1

  play ch[0]
  sleep 0.5
  play ch[1]
  sleep 0.5

  ch = treble_ch[2]

  play ch[2]
  sleep 1
end


define :fancy_melody_8 do
  ch = treble_ch[0]
  anticipation = 0.1

  play ch[0]
  sleep 1 - anticipation

  play ch[0]
  sleep 0.6 + anticipation
  play ch[0] + 2
  sleep 0.2
  play ch[0]
  sleep 0.2

  play ch[1]
  sleep 0.5
  play ch[2]
  sleep 0.5

  ch = treble_ch[1]

  play ch[2]
  sleep 1

  play ch[0]
  sleep 1

  play ch[1]
  sleep 1

  play ch[0]
  sleep 0.25
  play ch[1]
  sleep 0.75

  ch = treble_ch[2]

  play ch[2]
  sleep 1
end


define :second_melody_8 do
  ch = treble_ch[2]

  play ch[2]
  sleep 1

  play ch[2]
  sleep 1

  play ch[2]
  sleep 0.5
  play ch[1]
  sleep 0.5

  play ch[0]
  sleep 1

  second_melody_p2_4
end


define :second_melody_p2_4 do
  ch = treble_ch[2]

  play treble_ch[1][0]
  sleep 0.5
  play ch[0]
  sleep 0.5

  play treble_ch[0][0]
  sleep 0.5
  play ch[0]
  sleep 0.5

  play ch[0]
  sleep 0.5
  play ch[1]
  sleep 0.5

  play ch[2]
  sleep 1
end


define :main_chords_8 do
  3.times do
    play treble_ch[0]
    sleep 1
  end

  4.times do
    play treble_ch[1]
    sleep 1
  end

  1.times do
    play treble_ch[2]
    sleep 1
  end
end


define :second_chords_8 do
  4.times do
    play treble_ch[2]
    sleep 1
  end

  second_chords_p2_4
end


define :second_chords_p2_4 do
  2.times do
    play treble_ch[1]
    sleep 1
  end

  2.times do
    play treble_ch[2]
    sleep 1
  end
end


define :main_drums_8 do
  8.times do
    sample :bd_fat, amp: 0.6
    sleep 0.5
    sample :drum_snare_hard, amp: 0.3
    sleep 0.5
  end
end


define :speedy_drums_8 do
  8.times do
    sample :bd_fat, amp: 0.6
    sleep 0.25
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.25
    sample :drum_snare_hard, amp: 0.3
    sleep 0.25
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.25
  end
end


define :speedy_drums_4 do
  3.times do
    sample :bd_fat, amp: 0.6
    sleep 0.25
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.25
    sample :drum_snare_hard, amp: 0.3
    sleep 0.25
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.25
  end

  sample :bd_fat, amp: 0.6
  sleep 0.25
  sample :drum_cymbal_closed, amp: 0.6
  sleep 0.25
  sample :drum_snare_hard, amp: 0.3
  sleep 0.25
  sample :drum_cymbal_closed, amp: 0.6
  sleep 0.25 / 2.0
  sample :drum_cymbal_closed, amp: 0.6
  sleep 0.25 / 2.0
end


define :main_bass_8 do
  # Chord pattern: (should match main_melody_8)
  #
  # 0 * 3
  # 1 * 4
  # 2 * 1

  use_synth :dsaw
  opts = { amp: 0.3, release: 0.25 }
  ch = nil

  run_1 = proc do
    play ch[0], opts
    sleep 0.50
    play ch[1], opts
    sleep 0.25
    play ch[2], opts
    sleep 0.25
  end

  ch = bass_ch[0]
  3.times(&run_1)
  ch = bass_ch[1]
  4.times(&run_1)
  ch = bass_ch[2]
  1.times(&run_1)
end


define :alt_main_bass_8 do
  # Chord pattern: (should match main_melody_8)
  #
  # 0 * 3
  # 1 * 4
  # 2 * 1

  use_synth :dsaw
  opts = { amp: 0.3, release: 0.25 }
  ch = nil

  first_run_1 = proc do
    play ch[0], opts
    sleep 0.50
    play ch[1], opts
    sleep 0.25
    play ch[2], opts
    sleep 0.25
  end
  second_run_1 = proc do
    play ch[0], opts
    sleep 0.25
    play ch[0], opts
    sleep 0.25
    play ch[1], opts
    sleep 0.25
    play ch[2], opts
    sleep 0.25
  end

  ch = bass_ch[0]
  1.times(&first_run_1)
  1.times(&second_run_1)
  1.times(&first_run_1)
  ch = bass_ch[1]
  2.times(&first_run_1)
  2.times(&second_run_1)
  ch = bass_ch[2]
  1.times(&first_run_1)
end


define :second_bass_8 do
  use_synth :dsaw
  ch = bass_ch[2]
  opts = { amp: 0.3, release: 0.25 }

  4.times do
    play ch[0], opts
    sleep 0.25
    play ch[1], opts
    sleep 0.25
    play ch[2], opts
    sleep 0.25
    play ch[3], opts
    sleep 0.25
  end

  second_bass_4
end


define :second_bass_4 do
  use_synth :dsaw
  ch = bass_ch[2]
  opts = { amp: 0.3, release: 0.25 }

  4.times do |i|
    ch = i <= 1 ? bass_ch[1] : bass_ch[2]

    play ch[0], opts
    sleep 0.25
    play ch[1], opts
    sleep 0.25
    play ch[2], opts
    sleep 0.25
    play ch[3], opts
    sleep 0.25
  end
end


# Change this to start at a later track
start_at = 0


#
# Here, the structure of each of the tracks are laid out.
#
# Each track should have the same number of beats in order for things to not
# get super confusing.
#
threads = {
  melody: [
    :main_melody_8,
    :fancy_melody_8,
    :second_melody_8,
    :second_melody_p2_4,
    :fancy_melody_8,
    :fancy_melody_8,
  ],
  chords: [
    :main_chords_8,
    :main_chords_8,
    :second_chords_8,
    :second_chords_p2_4,
    :main_chords_8,
    :main_chords_8,
  ],
  drums: [
    -> { sleep 8 },
    :main_drums_8,
    :main_drums_8,
    :speedy_drums_4,
    :speedy_drums_8,
    :speedy_drums_8,
  ],
  bass: [
    -> { sleep 8 },
    -> { sleep 8 },
    :second_bass_8,
    :second_bass_4,
    :main_bass_8,
    :alt_main_bass_8,
  ]
}


#
# Play all of the threads, starting at 'start_at'
#
threads.each do |name, sequence|
  in_thread name: name do
    sequence[start_at..-1].each do |action|
      case action
      when Symbol
        send(action)
      when Proc
        action.call
      else
        raise "WTF? Dunno how to do #{action.inspect}"
      end
    end
  end
end
