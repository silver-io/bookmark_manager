require 'spec_helper'

feature "User adds a new link" do

  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    visit "/"
    add_link("http://www.makersacademy.com/", 
    	"Makers Academy", 
    	['education','ruby'])    
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  def add_link(url, title, tags = [])
    within('#new-link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end      
  end
  
  scenario "with a password that doesn't match" do
    # lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)    
    expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(1)  
  end

  def sign_up(email = "alice@example.com", 
              password = "oranges!", 
              password_confirmation = "oranges!")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end


end