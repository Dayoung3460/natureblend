const express = require('express');
const router = express.Router();
const inputService = require('../../service/sales/input_service.js');


//창고조회
router.get('/input/warehouse',async(req,res)=>{
    let warehouseList = await inputService.getWarehouse();
    res.send(warehouseList);
})

//품질검사조회 
router.put('/input/qtsearch',async(req,res)=>{
    let {productCode, startDate,endDate } = req.body;
    
    let result = await inputService.getQtList(productCode,startDate,endDate);
    console.log("결과:",result)
    res.send(result);
  
})

















module.exports = router;