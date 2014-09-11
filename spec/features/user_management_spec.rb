require_relative 'helpers/session'
include SessionHelpers

feature "User signs up" do

  scenario "when being logged out" do    
    expect { sign_up }.to change(User, :count).by(1)  
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")        
  end

  scenario "with a password that doesn't match" do
    # lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)    
    expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match")  
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

    def sign_up(email = "alice@example.com", password = "oranges!", password_confirmation = "oranges!")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end

end

feature "User signs in" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User signs out' do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end
end

feature 'User forgets their password' do

  before(:each) do
        User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario 'when trying to sign in' do
    visit '/sessions/new'
    expect(page).to have_content("Retrieve password")
    click_link "Retrieve password"
    expect(page.current_path).to eq '/users/reset_password'
  end

  scenario "when resetting password" do
    visit '/users/reset_password'
    expect(page).to have_field "email"
    fill_in "email", with: "test@test.com"
    click_button "request password"
    expect(page).to have_content("password token has been sent")
  end

end






