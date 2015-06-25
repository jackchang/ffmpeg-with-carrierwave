module CarrierWave
  module Ffmpeg
    class AudioTranscoder
      def initialize(format, input_file_path, output_file_path, options)
        @input_file_path = input_file_path
        @output_file_path = output_file_path
        @format = format.to_s
        @custom = options.delete(:custom)
        @audio_codec = options.delete(:audio_codec)
        @audio_bitrate = options.delete(:audio_bitrate)
      end

      def run
        begin
          file = ::FFMPEG::Movie.new(@input_file_path)
          file.transcode(@output_file_path, format_params)
          File.rename @output_file_path, @input_file_path
        rescue => e
          raise CarrierWave::ProcessingError.new("Failed to transcode with FFmpeg.Error: #{e}")
        end
      end

      private
      
      def format_params
        {
          audio_codec: @audio_codec,
          audio_bitrate: @audio_bitrate,
          custom: @custom,
        }.reject{|k,v| v.blank?}
      end
      
      def encoder_options
        { preserve_aspect_ratio: :width }
      end
    end
  end
end
