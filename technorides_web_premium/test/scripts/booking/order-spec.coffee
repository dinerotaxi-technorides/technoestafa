describe "Login-succes", ->

  it "Should go to login", ->
    browser.get "http://localhost/booking/#rtaxi/16887"
    loginLink = $("a[href='#login']")
    expect(loginLink.isPresent()).toBe(true)
    loginLink.click()

  it "Should enter user and password", ->
    element(By.model("credentials.user")).sendKeys("oslo@norw.com")
    element(By.model("credentials.password")).sendKeys("oslo@norw.com")
    element(By.css(".btn")).click()

  it "should login successfuly", ->  
    expect(element(By.css(".please-log-in")).isPresent()).toBeFalsy()
    expect(browser.getLocationAbsUrl()).toMatch("/order")

describe "make-order and cancel", ->

  it "should make an order", ->
    element(By.model("origin.number")).sendKeys("328")
    element(By.model("destination.city")).sendKeys("CABA")
    element(By.model("destination.street")).sendKeys("Av. Santa fe")
    element(By.model("destination.number")).sendKeys("1000")
    element(By.css(".btn")).click()

  it "should create a trip", ->
    # Expect to get trip id
    expect(element(By.css(".cancel")).isPresent()).toBe(true)

  it "should cancel the order", ->
    element(By.css(".cancel")).click()

    browser.driver.sleep(1)
    browser.waitForAngular()

    expect(element(By.css(".backgroud-error")).isPresent()).toBe(true)
    expect(element(By.css(".error-screen")).isPresent()).toBe(true)
    expect(element(By.css(".error-screen .btn-info")).isPresent()).toBe(true)
