require 'cuba'
require 'tilt/erb'
require 'forex'

Cuba.define do
  on get do
    on root do
      template = Tilt::ERBTemplate.new('templates/index.erb')
      res.write template.render { }
    end
  end

  on post do
    on root do
      template = Tilt::ERBTemplate.new('templates/index.erb')

      on param('date'), param('amount'), param('base'), param('counter') do |date, amount, base, counter|
        forex = ExchangeRate.at(date, base, counter).to_f * amount.to_f
        res.write template.render { "#{base} #{amount} = #{counter} #{forex} ON #{date}" }
      end

      on true do
        res.write template.render { 'Please provide date, amount, and base and counter currencies' }
      end
    end
  end
end
