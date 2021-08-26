import * as utils from './util/utils'
    
after(async function() { 
    await utils.writeLog()   
    await browser.close()
})