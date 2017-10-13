# Case of login with empty form
describe "Login-empty", ->

  it "Should login with error", ->
    browser.get("http://localhost/login").then ->
      browser.driver.sleep(2)

      element(By.css(".btn")).click()
      expect(element(By.css("#gritter-notice-wrapper")).isPresent()).toBe(true)

# Case of a failure login
describe "Login-error", ->

  it "Should enter user and password", ->
    browser.get "http://localhost/login"
    element(By.model("credentials.user")).sendKeys("dsadasdsadas@dasdsadsa.com")
    element(By.model("credentials.password")).sendKeys("dsadsaadsa")
    element(By.css(".btn")).click()

  it "Should throw error message", ->
    expect(element(By.css("#gritter-notice-wrapper")).isPresent()).toBe(true)

# case of a successfull login
describe "Login-success", ->

  it "Should enter user and password", ->
    browser.get "http://localhost/login"
    element(By.model("credentials.user")).sendKeys("testoperador@suempresa.com")
    element(By.model("credentials.password")).sendKeys("12345")
    element(By.css(".btn")).click()

  it "Should login successfuly", ->  
    expect(browser.getLocationAbsUrl()).toMatch("/dispatcher")

describe "Logout-success", ->
  it "Should logout", ->
    logoutLink = $("a[ng-click='logout()']")
    logoutLink.click()


# case of a successfull login
describe "Login-success", ->

  it "Should enter user and password", ->
    browser.get "http://localhost/login"
    element(By.model("credentials.user")).sendKeys("testoperador@suempresa.com")
    element(By.model("credentials.password")).sendKeys("12345")
    element(By.css(".btn")).click()

  it "Should login successfuly", ->  
    expect(element(By.css(".please-log-in")).isPresent()).toBeFalsy()
    expect(browser.getLocationAbsUrl()).toMatch("/dispatcher")

describe "Logout-success", ->
  it "Should logout", ->
    logoutLink = $("a[ng-click='logout()']")
    logoutLink.click()


