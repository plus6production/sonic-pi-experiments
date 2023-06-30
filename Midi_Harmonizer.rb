# MIDI-controlled harmonizer?
# start with one "voice" and build

thread_name_base = "harmony_thread_"
input_name_base = "harmony_input_"
cue_name_base = "harmony_off_"
mic_amp = 1.0
fade_in_time = 0.5
fade_time = 0.2
mic_input = 15
midi_device = "/midi:komplete_kontrol_-_1_5:1"

live_start_lambda = -> (name, input_num) { live_audio name, input: input_num }
live_stop_lambda = -> (name) { live_audio name, :stop }

define :run_harmony do | audio_start_func, audio_stop_func, note |
  in_thread do
    use_real_time
    live_name = input_name_base.dup << note.to_s
    with_fx :reverb, room: 0.8, mix: 0.4 do
      with_fx :compressor, amp: mic_amp do
        with_fx :autotuner, formant_ratio: 0.95, note: note, amp: 0 do |at|
          
          # Start the audio input
          audio_start_func.call(live_name, mic_input)
          #live_audio live_name, input: mic_input
          
          # Fade in
          control at, _slide: fade_in_time, amp: 1.0
          
          # Wait for note off
          sync (cue_name_base.dup << note.to_s)
          
          # Fade out
          # Fade in
          control at, _slide: fade_time, amp: 0
          sleep fade_time
          
          # Stop the audio input
          #live_audio live_name, :stop
          audio_stop_func.call(live_name)
        end
      end
    end
  end
end

with_fx :reverb, room: 0.9, mix: 0.4 do
  
  ##| with_fx :octaver, subsub_amp: 0, super_amp: 0, mix: 0.4 do
  with_fx :compressor, amp: mic_amp do
    with_fx :hpf, cutoff: hz_to_midi(280) do
      with_fx :eq, high_shelf: 0.3, high_shelf_note: hz_to_midi(6000) do
        live_audio "lead_vox", input: mic_input
      end
    end
  end
  ##| end
  ##| live_audio "lead_vox", :stop
  
  live_loop :midi_harmonizer do
    use_real_time
    note, velocity = sync midi_device.dup << "/note_on"
    run_harmony live_start_lambda, live_stop_lambda, note
  end
  
end

live_loop :midi_off_watcher do
  cue_name_base = "harmony_off_"
  use_real_time
  note, velocity = sync midi_device.dup << "/note_off"
  cue (cue_name_base.dup << note.to_s)
end