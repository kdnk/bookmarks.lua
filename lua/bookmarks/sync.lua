local core = require("bookmarks.core")
local bookmark = require("bookmarks.bookmark")
local sign = require("bookmarks.sign")
local config = require("bookmarks.config")

local M = {}

function M.sync_bookmarks_to_signs()
    sign.remove_all_signs()

    local bookmarks = bookmark.get_bookmarks()
    core.list.each(bookmarks, function(b)
        sign.add_sign(b.bufnr, b.lnum)
    end)
end

---@param bufnr integer
---@param lnum number
function M.add(bufnr, lnum)
    sign.add_sign(bufnr, lnum)
    bookmark.add_bookmark(bufnr, lnum)
end

---@param bufnr integer
---@param lnum number
function M.delete(bufnr, lnum)
    sign.delete_sign(bufnr, lnum)
    bookmark.delete_bookmark(bufnr, lnum)
end

function M.write()
    if config.persist then
        local json = bookmark.serialize()
        vim.fn.writefile(json, config.serialize_path)
    end
end

function M.read()
    if config.persist then
        bookmark.update_bookmarks(bookmark.deserialize())
        M.sync_bookmarks_to_signs()
    end
end

return M
