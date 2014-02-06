var key, require, require_test, val, _ref, _ref1;

require_test = {
  paths: {
    mocha: 'vendors/mocha/mocha',
    chai: 'vendors/chai/chai',
    sinon: 'vendors/sinon/index'
  },
  shim: {
    mocha: {
      exports: 'mocha'
    },
    chai: {
      exports: 'chai'
    },
    sinon: {
      exports: 'sinon'
    }
  }
};

require = window.require || {};

_ref = require_test.paths;
for (key in _ref) {
  val = _ref[key];
  require.paths[key] = val;
}

_ref1 = require_test.shim;
for (key in _ref1) {
  val = _ref1[key];
  require.shim[key] = val;
}
