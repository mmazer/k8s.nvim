local lib = require("u.plugins.kubectl.lua.kubectl.lib")
describe("lib", function()
    describe("table_defaults", function()
      it("should add the defaults if not present", function()
        local dst = {a="a", b="b"}
        local defaults = {c="c"}
        lib.table_defaults(dst, defaults)
        assert.are.equal(dst["c"], "c")
      end)

      it("should not override values", function()
        local dst = {a="a", b="b", c="c"}
        local defaults = {c="C"}
        lib.table_defaults(dst, defaults)
        assert.are.equal(dst["c"], "c")
      end)
    end)
end)
