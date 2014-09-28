module Remotable
  extend ActiveSupport::Concern

  included do
    MIN_REMOTE_IMAGE_SIZE = 500 * 500

    before_create :ensure_remote_image_size

    protected

    def ensure_remote_image_size
      return if remote_image_area(remote_image_url) >= MIN_REMOTE_IMAGE_SIZE

      self.remote_image_url = sorted_remote_image_srcs.first
    end

    def remote_page
      @remote_page ||= Nokogiri::HTML(open(url))
    end

    def remote_image_area(url)
      FastImage.size(url).try(:reduce, :*) || 0
    end

    def remote_image_file_size(url)
      response = Net::HTTP.get_response(URI(url))
      response['content-length'].to_i || 0

    rescue StandardError
      0
    end

    def remote_image_srcs
      return @remote_image_srcs if @remote_image_srcs

      xpaths = [
        '//article//img/@src',
        '//*[@itemtype="http://schema.org/BlogPosting"]//img/@src',
        '//h1/ancestor::section//img/@src',
        '//img/@src'
      ]

      srcs = []
      xpaths.each do |xpath|
        srcs.concat(remote_page.xpath(xpath))
        break if srcs.length > 0
      end

      @remote_image_srcs = srcs.map do |src|
        URI.join(url, URI.encode(src.value)).to_s
      end
    end

    def sorted_remote_image_srcs
      @sorted_remote_image_srcs ||= remote_image_srcs.sort_by do |src|
        remote_image_area(src) + remote_image_file_size(src)
      end.reverse
    end
  end
end
