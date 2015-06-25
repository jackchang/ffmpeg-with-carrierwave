module CarrierWave
  module Ffmpeg
    class VideoTranscoder
      def initialize(format, input_file_path, output_file_path, options)
        @input_file_path = input_file_path
        @output_file_path = output_file_path
        @format = format.to_s
        @resolution = options.delete(:resolution) || "640x360"
        @custom = options.delete(:custom)
        @keyframe_interval = options.delete(:keyframe_interval) || '30'
        @video_codec = options.delete(:video_codec)
        @video_bitrate = options.delete(:video_bitrate)
        @frame_rate = options.delete(:frame_rate)
        @audio_codec = options.delete(:audio_codec)
        @audio_bitrate = options.delete(:audio_rate)
      end

      def run
        begin
          file = ::FFMPEG::Movie.new(@input_file_path)
          file.transcode(@output_file_path, format_params){ |progress| p progress }
          File.rename @output_file_path, @input_file_path
        rescue => e
          raise CarrierWave::ProcessingError.new("Failed to transcode with FFmpeg.Error: #{e}, input: #{@input_file_path}, ouput: #{@output_file_path}")
        end
      end

      private
      
      def format_params
        {
          resolution: @resolution,
          keyframe_interval: @keyframe_interval,
          video_codec: @video_codec,
          video_bitrate: @video_bitrate,
          frame_rate: @frame_rate,
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
