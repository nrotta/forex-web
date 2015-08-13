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
        rate = ExchangeRate.at(date, base, counter)
        if rate && (amount.to_f != 0.0)
          res.write template.render { "#{base} #{amount} = #{counter} #{rate * amount.to_f} ON #{date}" }
        else
          res.write template.render { 'Please provide correct date, amount, and base and counter currencies' }
        end
      end

      on true do
        res.write template.render { 'Please provide date, amount, and base and counter currencies' }
      end
    end
  end
end
