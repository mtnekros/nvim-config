-- require("luasnip.session.snippet_collection").clear_snippets "markdown"
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local blog_outline_template = [[
# {title}

## Overview
{overview}

## {subtitle}{more_subtitle}

# Conclusion
{conclusion}

<Add a question here>
]]

local function add_tasks_recursively()
    return ls.snippet_node(
        nil,
        ls.choice_node(1, {
            ls.text_node(""),
            ls.snippet_node(nil, {
                ls.text_node({"", "* ["}), -- for new line
                ls.choice_node(1, {
                    ls.text_node(" "),
                    ls.text_node("X"),
                    ls.text_node("-")
                }),
                ls.text_node("] "),
                ls.insert_node(2, "task"),
                ls.dynamic_node(3, add_tasks_recursively),
           })
        })
    )
end

local function add_subtitle_recursively()
    return ls.snippet_node(
        nil,
        ls.choice_node(1, {
            ls.text_node(""),
            ls.snippet_node(nil, {
                ls.text_node({"", "",  "## "}),
                ls.insert_node(1, "<add subtitle here>"),
                ls.dynamic_node(2, add_subtitle_recursively, {}),
            }),
        })
    )
end

ls.add_snippets('markdown', {
    -- blog outline snippet
    ls.snippet('bol',
        fmt(blog_outline_template, {
            title = ls.insert_node(1, "title"),
            overview = ls.insert_node(2, "<add an hook here and/or the overview of the blog>"),
            subtitle = ls.insert_node(3, "subtitle"),
            more_subtitle = ls.dynamic_node(4, add_subtitle_recursively, {}),
            conclusion = ls.insert_node(5, "<add conclusion here>"),
        })
    ),
    -- tasks snippet
    ls.snippet('tasks',
        fmt("* [{check}] {task}{more_task}", {
            check = ls.choice_node(1, {ls.text_node(" "), ls.text_node("X"), ls.text_node("-")}),
            task  = ls.insert_node(2, "task"),
            more_task = ls.dynamic_node(3, add_tasks_recursively),
        })
   ),
})

