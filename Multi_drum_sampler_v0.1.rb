# First attempt at multisampled drums
# Requirements:
# - Multiple velocity levels mapped to different samples AND amplitudes
# - Round-robin samples per velocity level if desired
# Pretty sure that Sonic Pi sees velocity as 0-1 float

define :scale_val do | val, range1_min, range1_max, range2_min, range2_max |
  percent = (val - range1_min) / (range1_max - range1_min)
  out_val = (range2_max - range2_min) * percent + range2_min
  return out_val
end

define :multi_drum_sampler do | note, vel, sample_map |
  min_vel = 0.3
  max_vel = 1.0
  
  # If the sample map doesn't have info for this note,
  # currently just return early
  inst_samples = sample_map[note]
  return if not inst_samples
  
  num_levels = inst_samples.length
  unscaled_velocity_increment = 1.0 / num_levels
  scaled_velocity_increment = (max_vel - min_vel) / num_levels
  
  scaled_vel = scale_val vel, 0.0, 1.0, min_vel, max_vel
  level = ((scaled_vel - min_vel) / scaled_velocity_increment).round.clamp(num_levels-1)
  
  print note, level, vel, scaled_vel
  
  rr_samples = inst_samples[level]
  sample choose(rr_samples), amp: scaled_vel
end

# MIDI in loop for testing
##| live_loop :midi_drums_test do
##| use_real_time
##| sample_map = get :drums_sample_map
##| note, velocity = sync "/midi:komplete_kontrol_-_1_4:1/note_on"
##| multi_drum_sampler note, velocity/127.0, sample_map
##| end
