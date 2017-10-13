# Case of login with empty form
describe 'Login-empty', ->
  
  it 'Should go to login', ->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    loginLink = $('a[href="#login"]')
    expect(loginLink.isPresent()).toBe(true)
    loginLink.click()
  
  it 'Should login with error', ->
    element(By.css('.btn')).click()
    model1 = element(By.model('credentials.user')).getAttribute('class')
    expect(model1).toContain('ng-invalid')
    expect(model1).toContain('submited')

# Case of a failure login
describe 'login-error', ->

  it 'Should go to login', ->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    loginLink = $('a[href="#login"]')
    expect(loginLink.isPresent()).toBe(true)
    loginLink.click()

  it 'Should enter user and password', ->
    element(By.model('credentials.user')).sendKeys('dsadasdsadas@dasdsadsa.com')
    element(By.model('credentials.password')).sendKeys('dsadsaadsa')
    element(By.css('.btn')).click()

  it 'should trhow error message', ->
    expect(element(By.css('.backgroud-error')).isPresent()).toBe(true)
    expect(element(By.css('.error-screen')).isPresent()).toBe(true)

# case of a successfull login
describe 'Login-succes', ->
  
  it 'Should go to login', ->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    loginLink = $('a[href="#login"]')
    expect(loginLink.isPresent()).toBe(true)
    loginLink.click()
  
  it 'Should enter user and password', ->
    element(By.model('credentials.user')).sendKeys('oslo@norw.com')
    element(By.model('credentials.password')).sendKeys('oslo@norw.com')
    element(By.css('.btn')).click()
  
  it 'should login successfuly', ->  
    expect(element(By.css('.please-log-in')).isPresent()).toBeFalsy()
    expect(browser.getLocationAbsUrl()).toMatch("/order")

describe 'Logout-success', ->
  it 'Should logout', ->
    logoutLink = $('a[ng-click="logout()"]')
    logoutLink.click()


