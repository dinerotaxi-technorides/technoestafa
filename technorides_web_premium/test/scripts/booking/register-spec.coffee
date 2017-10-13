describe 'register-empty',->

  it 'Should go to register',->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    registerLink = $('a[href="#register"]')
    expect(registerLink.isPresent()).toBe(true)
    registerLink.click()

  it 'Should send register', ->
    element(By.css('.btn')).click()

  it 'Should apear red fields', ->  
    model1 = element(By.model('credentials.email')).getAttribute('class')
    expect(model1).toContain('ng-invalid')
    expect(model1).toContain('submited')

describe 'register error', ->
  
  it 'Should go to register',->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    registerLink = $('a[href="#register"]')
    expect(registerLink.isPresent()).toBe(true)
    registerLink.click()
  
  it 'Should fill the form, with wrong data', ->
    element(By.model('credentials.email')).sendKeys('dsdas@dsa')
    element(By.model('credentials.password')).sendKeys('dsda')
    element(By.model('credentials.name')).sendKeys('dasd')
    element(By.model('credentials.surname')).sendKeys('dsa')
    element(By.model('credentials.phone')).sendKeys('123')
  
  it 'Should send the form and get error',->
    element(By.css('.btn')).click()
    expect(element(By.css('.backgroud-error')).isPresent()).toBe(true)
    expect(element(By.css('.error-screen')).isPresent()).toBe(true)

describe 'register success', ->

  it 'Should go to register',->
    browser.get 'http://localhost/booking/#rtaxi/16887'
    registerLink = $('a[href="#register"]')
    expect(registerLink.isPresent()).toBe(true)
    registerLink.click()
  
  it 'should generate random addres', ->
    date = new Date();
    date = date.getTime()
    
    element(By.model('credentials.email')).sendKeys("test_#{date}@test.com")
    element(By.model('credentials.password')).sendKeys('Testing')
    element(By.model('credentials.name')).sendKeys('Testing')
    element(By.model('credentials.surname')).sendKeys('Testing')
    element(By.model('credentials.phone')).sendKeys('0800-test-test')
    element(By.css('.btn')).click()

  it 'should login successfuly', ->  
    expect(element(By.css('.please-log-in')).isPresent()).toBeFalsy()
    expect(browser.getLocationAbsUrl()).toMatch("/order")

describe 'Logout-success', ->
  it 'Should logout', ->
    logoutLink = $('a[ng-click="logout()"]')
    logoutLink.click()

# we didnt do register succes cause it will work only once
  
