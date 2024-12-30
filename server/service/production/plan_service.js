const mysql = require('../../database/mapper');

const findAllProducts = async ()=>{
    return await mysql.query('productList');
}

const findOrders = async (productCode)=>{
    let sql = !productCode ? 'orders': 'ordersByProductCode';
    return await mysql.query(sql, [productCode]);
}

const findProductStock = async (productCode)=>{
    let result = await mysql.query('productStock', [productCode]);
    return result[0][0]
}

const getProductionEmpList = async ()=>{
    return await mysql.query('productionEmployees');
}

const addPlan = async (planInfo)=>{
    let result = await mysql.query('insertPlanByOrders', Object.values(planInfo));
    return { message: result[0][0].result }
}

const planList = async (urlQuery)=>{
    if(Object.keys(urlQuery).length === 0) {
        return await mysql.query('planDetailList')
    } else {
        let dbQuery = ''
        if(urlQuery.productCode) {
            dbQuery += ` and product_code = '${urlQuery.productCode}'`
        }
        if(urlQuery.status) {
            let output = urlQuery.status
                .split(',')
                .map(item => `'${item}'`)
                .join(',')
            dbQuery += ` and plan_status in (${output})`
        }
        if(urlQuery.startDate) {
            dbQuery += ` and plan_start_date >= '${urlQuery.startDate}'`
        }
        if(urlQuery.endDate) {
            dbQuery += ` and plan_end_date <= '${urlQuery.endDate}'`
        }

        return await mysql.query('planDetailList', dbQuery)
    }
}

module.exports = {
    findAllProducts,
    findOrders,
    findProductStock,
    getProductionEmpList,
    addPlan,
    planList
}