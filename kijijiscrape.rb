require 'open-uri'
require 'nokogiri'

class Kijiji
	def initialize(url)
		@url = url
		@doc = Nokogiri::HTML(open(@url))
	end
	
	def country
		@country = @doc.at("meta[@property='og:country-name']")['content']
	end
	
	def locality
		@locality = @doc.at("meta[@property='og:locality']")['content']
	end
	
	def category
		@category = @doc.at("meta[@name='WT.cg_s']")['content']
	end
	
	def description
		@description = @doc.at("meta[@property='og:description']")['content']
	end
	
	def title
		@title = @doc.at("meta[@property='og:title']")['content']
	end
	
	def image_url
		@image = @doc.at("meta[@property='og:image']")['content']
		@image = "None" if @image.end_with?('logo.gif') # exclude the default Kijiji image
	end
	
	def attributes
		@attrs = {}
		attribute_table = @doc.css('table#attributeTable')
		attribute_tr = attribute_table.css('tr')
		attribute_tr.each do |row|
			attribute_td = row.css('td')
			continue unless attribute_td.count == 2
			# Add to our hash while removing new lines and whitespace
			@attrs[attribute_td[0].inner_text.gsub(/[\n\s]/, '')] = attribute_td[1].inner_text.gsub("\n", '')
		end
		@attrs
	end
end