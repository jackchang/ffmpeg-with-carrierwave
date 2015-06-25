require 'streamio-ffmpeg'
require 'ffmpeg/video_transcoder'
require 'ffmpeg/audio_transcoder'

module CarrierWave
  module Ffmpeg
    extend ActiveSupport::Concern
    module ClassMethods
      def encode_ffmpeg(target_format, options={})
        process encode_ffmpeg: [target_format, options]
      end
    end
    
    def encode_ffmpeg(format, opts={})
      cache_stored_file! unless cached?
      tmp_path = File.join( File.dirname(current_path), "tmpfile.#{format}" )
      case format.to_s
      when /ogv|webm|mp4/
        CarrierWave::Ffmpeg::VideoTranscoder.new(format, current_path, tmp_path, opts).run
      when /mp3|aac|wav|ogg|flac/
        CarrierWave::Ffmpeg::AudioTranscoder.new(format, current_path, tmp_path, opts).run
      else
        raise CarrierWave::ProcessingError.new("Can not handle this type.")
      end
    end
  end
end
