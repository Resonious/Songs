# frozen_string_literal: true

use_bpm 90

treble_ch = [
  (chord :c4, :m7),
  (chord :d4, :m7),
]

high_ch = [
  (chord :c5, :m7),
  (chord :d5, :m7),
]

bass_ch = [
  (chord :c2, :m7),
  (chord :d2, :m7),
]

melody_synth = :pretty_bell
melody_opts = { amp: 1, note_slide: 0.5 }

harmony_synth = :zawa
harmony_opts = { amp: 0.2, release: 0.2, note_slide: 0.5 }

trebber_synth = :saw
trebber_opts = { amp: 0.5, release: 0.5 }

bass_synth = :fm
bass_opts = { amp: 1.1 }


define :harmony_1 do
  use_synth harmony_synth
  opts = harmony_opts

  ch = high_ch[0]

  4.times { play_pattern_timed ch, 0.25, opts }

  ch = high_ch[1]

  4.times { play_pattern_timed shuffle(ch), 0.25, opts }
end


define :melody_1 do
  use_synth melody_synth
  opts = melody_opts

  ch = treble_ch[0]

  play ch[2], opts
  sleep 1

  play ch[0]-2, opts
  sleep 0.25
  play ch[0]-1, opts
  sleep 0.25
  play ch[0], opts
  sleep 0.5

  play ch[1], opts
  sleep 2

  ch = treble_ch[1]

  play ch[2], opts
  sleep 1

  play ch[0]-2, opts
  sleep 0.25
  play ch[0]-1, opts
  sleep 0.25
  play ch[0], opts
  sleep 0.5

  play ch[1], opts
  sleep 2
end


define :melody_2 do
  use_synth melody_synth
  opts = melody_opts

  ch = treble_ch[0]

  play ch[2], opts
  sleep 0.5
  play ch[0]-2, opts
  sleep 0.25
  play ch[0]-1, opts
  sleep 0.25

  play ch[0], opts
  sleep 0.5
  play ch[0]+1, opts

  play ch[1], opts
  sleep 2

  ch = treble_ch[1]

  play ch[2], opts
  sleep 1

  play ch[0]-2, opts
  sleep 0.25
  play ch[0]-1, opts
  sleep 0.25
  play ch[0], opts
  sleep 0.5

  play ch[1], opts
  sleep 2
end


define :sway do
  use_synth melody_synth
  opts = melody_opts

  ch = treble_ch[0]

  s = play ch[2], opts.merge(sustain: 2, release: 4)
  sleep 1

  control s, note: ch[0]
  sleep 1

  control s, note: ch[1]
  sleep 1

  play ch[0], opts
  sleep 1

  ch = treble_ch[1]

  s = play ch[2], opts.merge(sustain: 2, release: 4)
  sleep 1

  control s, note: ch[0]
  sleep 1

  control s, note: ch[1]
  sleep 1

  play ch[0], opts
  sleep 1
end


define :test do
  use_synth bass_synth
  opts = bass_opts

  ch = bass_ch[0]

  play ch[0], opts
  sleep 1

  play ch[1], opts
  sleep 1

  play ch[2], opts
  sleep 1

  play ch[1], opts
  sleep 1

  ch = bass_ch[1]

  play ch[0], opts
  sleep 1

  play ch[1], opts
  sleep 1

  play ch[2], opts
  sleep 1

  play ch[1], opts
  sleep 1
end


define :trebber do
  use_synth trebber_synth
  opts = trebber_opts

  ch = bass_ch[0]

  play ch[0], opts.merge(release: 4)
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[2], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[0], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[2], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  ch = bass_ch[1]

  play ch[2], opts.merge(release: 4)
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[2], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[0], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5

  play ch[2], opts
  sleep 0.5
  play ch[1], opts
  sleep 0.5
end


define :drums do
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



# Change this to start at a later track
start_at = [0]
repeat = 1


#
# Here, the structure of each of the tracks are laid out.
#
# Each track should have the same number of beats in order for things to not
# get super confusing.
#
threads = {
  melody: [
    :melody_1, :melody_1, :melody_2
  ],
  harmony: [
    :harmony_1, :harmony_1, :harmony_1
  ],
  whatever: [
    :test, :test, :test
  ],
  percussion: [
    :drums, :drums, :drums
  ],
  treb: [
    # -> { sleep 8 },
    :trebber,
    :trebber
  ]
}


#
# Sanity check: make sure all threads have the same number of actions
#
action_count = 0
threads.each do |name, sequence|
  if action_count.zero?
    action_count = sequence.size
    next
  end
  if sequence.size != action_count
    raise "#{name} has #{sequence.size} actions but should have #{action_count}"
  end
end

#
# Play all of the threads, starting at 'start_at'
#
threads.each do |name, sequence|
  in_thread name: name do
    repeat.times do |i|
      sequence[start_at[i]..-1].each do |action|
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
end
