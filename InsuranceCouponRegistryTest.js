const utils = require('./Utils')

const checkState = utils.checkState
const checkEvent = utils.checkEvent
const insuranceReg = utils.InsuranceCouponRegistry
const propertyReg = utils.PropertyRegistry

const meta  = "meta"

contract('InsuranceCouponRegistry', async function (accounts) {


    beforeEach('Make fresh contract', async function () {
        InsuranceCouponRegistry =  InsuranceCouponRegistry.new()
        PropertyRegistry =  PropertyRegistry.new()

    })
  
    it('should have correct initial state', async function () {
        await checkState([InsuranceCouponRegistry], [[]], accounts)
    })
  
    it('should generate a coupon', async function () {
        let event = InsuranceCouponRegistry.createInsuranceCoupon(meta, 5, accounts[0], 1, PropertyRegistry)
        checkEvent('CouponCreated', event, [accounts[0], 1])

    })

    
  })