require_test =
  paths:
    mocha: 'vendors/mocha/mocha'
    chai: 'vendors/chai/chai'
    sinon: 'vendors/sinon/index'
  shim:
    mocha:
      exports: 'mocha'
    chai:
      exports: 'chai'
    sinon:
      exports: 'sinon'

require = window.require || {}

for key, val of require_test.paths
  require.paths[key] = val
for key, val of require_test.shim
  require.shim[key] = val