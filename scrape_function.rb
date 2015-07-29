require "pry"

require 'capybara/poltergeist'

# Configure Poltergeist to not blow up on websites with js errors aka every website with js
# See more options at https://github.com/teampoltergeist/poltergeist#customization
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

# Configure Capybara to use Poltergeist as the driver
Capybara.default_driver = :poltergeist

def scrape(isbnList)
	browser = Capybara.current_session
	isbnList.collect do |isbn|
		browser.visit 'http://amazon.com'
		browser.fill_in 'twotabsearchtextbox', :with => isbn
		browser.click_on 'Go'
		bookElement = browser.find '.a-link-normal.s-access-detail-page.a-text-normal'
		#finds book link on list of search results
		bookElement.click
		#arrived at book's page

		title = browser.find('#productTitle').text

		publisher = browser.find('li', :text => 'Publisher').text
		publisher = publisher.match(/:.*\(/)

		date = browser.find('li', :text => 'Publisher').text
		date = date.match(/\(.*\)/)

		isbnTen = browser.find('li', :text => 'ISBN-10').text
		isbnTen = isbnTen.match(/[1234567890X]{10}/)

		isbnThirteen = browser.find('li', :text => 'ISBN-13').text
		isbnThirteen = isbnThirteen.match(/\d{3}-\d{10}/)

		#bindingType = browser.find('li', :text => 'pages').text
		#bindingType = bindingType.match(/\w*:/)

		results = []

		   results.push({:title => title, 
			:publisher => publisher, 
			:date => date, 
			:isbn10 => isbnTen, 
			:isbn13 => isbnThirteen,
			#:bindingType => bindingType
			 })
	end
end
binding.pry