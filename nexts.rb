# frozen_string_literal: true

use_bpm 90

treble_ch = [
  (chord :c2, :minor),
  (chord :d2, :minor),
]

bass_ch = [
  (chord :c2, :minor),
  (chord :d2, :minor),
]

treb_synth = :saw
treb_opts = { amp: 0.5, release: 0.5 }

bass_synth = :fm
bass_opts = { amp: 1.1 }


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
  use_synth treb_synth
  opts = treb_opts

  ch = treble_ch[0]

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

  ch = treble_ch[1]

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
  whatever: [
    :test, :test
  ],
  percussion: [
    :drums, :drums
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
