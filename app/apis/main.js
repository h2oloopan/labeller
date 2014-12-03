// Generated by CoffeeScript 1.8.0
var fs, input, output, path, sorting, storage;

fs = require('fs');

path = require('path');

storage = require('../helpers/storage');

input = path.resolve('input');

output = path.resolve('output');

sorting = function(a, b) {
  a = parseInt(a);
  b = parseInt(b);
  return a - b;
};

exports.bind = function(app) {
  app.get('/apis/questions/next', function(req, res) {
    var content, file, inputs, json, outputs, _i, _len, _ref;
    console.log('wth');
    inputs = fs.readdirSync(input);
    outputs = fs.readdirSync(output);
    _ref = inputs.sort(sorting);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      file = _ref[_i];
      if (outputs.indexOf(file) < 0 && !storage.exist(app, file)) {
        console.log(file);
        content = fs.readFileSync(path.join(input, file), {
          encoding: 'utf8'
        });
        json = {
          file: file,
          data: JSON.parse(content)
        };
        storage.set(app, file);
        return res.status(200).send(json);
      }
    }
    return res.status(404).send({});
  });
  return app.post('/apis/questions/new', function(req, res) {
    var data, err, file, question, questions;
    file = req.body.file;
    question = req.body.question;
    questions = req.body.questions;
    data = {};
    data[question] = questions;
    data = JSON.stringify(data);
    file = path.join(output, file);
    try {
      fs.writeFileSync(file, data);
    } catch (_error) {
      err = _error;
      return res.status(500).send(err);
    }
    return res.status(200).send({});
  });
};
