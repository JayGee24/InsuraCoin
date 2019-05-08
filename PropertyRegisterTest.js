const utils = require('./Utils')

const checkState = utils.checkState
const checkEvent = utils.checkEvent
const propertyReg = utils.PropertyRegistry

const meta  = "meta"

contract('PropertyRegisterTest', async function (accounts) {


  beforeEach('Make fresh contract', async function () {
    PropertyRegistry =  PropertyRegistry.new()
      
  })

  it('should have correct initial state', async function () {
    await checkState([PropertyRegistry], [[]], accounts)
  })

  it('should add a property', async function () {
    let event = await propertyReg.registerProperty(1, meta)
    checkEvent('PropertyRegistered', event, [accounts[0], 1])
  })
  

  it('should verify property'), async function () {
      let verified = await propertyReg.verifyPropertyOwnership()
      assert(verified == true)
  }
  
})