local lib = require("kubectl.lib")
local assert = require("luassert")
local busted = require("plenary.busted")
local describe = busted.describe
local it = busted.it

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

    describe("table_extend", function()
      it("should add the values", function()
        local dst = {a="a", b="b"}
        local src = {b="B", c="c"}
        lib.table_extend(dst, src)
        assert.are.equal(dst["b"], "B")
        assert.are.equal(dst["c"], "c")
      end)
    end)

    describe("tail", function()
      it("should return the element of a list except the first", function()
        local l = {1,2,3}
        local t = lib.tail(l)
        assert.are.equal(2, #t)
      end)
    end)
    describe("table_slice", function()
      it("should return a table of sliced element", function()
        local l = {1,2,3}
        local sliced = lib.table_slice(l, 2)
        assert.are.equal(2, #sliced)
        assert.are.equal(2, sliced[1])
        assert.are.equal(3, sliced[2])
      end)
    end)
end)
