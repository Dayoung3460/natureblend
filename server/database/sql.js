const boards = require('./sqls/boards.js');
const comments = require('./sqls/comments.js');
const books = require('./sqls/books.js');
const emp = require('./sqls/emp.js')

const productionPlan = require('./sqls/production/productionPlan')

module.exports = {
  ...boards,
  ...comments,
  ...books,
  ...emp,
  ...productionPlan,
}