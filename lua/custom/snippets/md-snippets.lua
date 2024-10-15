-- require("luasnip.session.snippet_collection").clear_snippets "markdown"
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local function get_current_date()
    local function formatted_day(day)
        local last_digit = day % 10
        local suffix = "th"
        if last_digit == 1 and day ~= 11 then
            suffix = "st"
        elseif last_digit == 2 and day ~= 12 then
            suffix = "nd"
        elseif last_digit == 3 and day ~= 13 then
            suffix = "rd"
        end
        return tostring(day) .. suffix
    end
    local day = tonumber(os.date("%d"))
    local formatted_date = tostring(os.date("%A, {day} %B %Y"))
    return string.gsub(formatted_date, "{day}", formatted_day(day))
end


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
        fmt(
            [[
            # {title}

            ## Overview
            {overview}

            ## {subtitle}{more_subtitle}

            # Conclusion
            {conclusion}

            <Add a question here>{last_cur_pos}
            ]],
            {
                title = ls.insert_node(1, "title"),
                overview = ls.insert_node(2, "<add an hook here and/or the overview of the blog>"),
                subtitle = ls.insert_node(3, "subtitle"),
                more_subtitle = ls.dynamic_node(4, add_subtitle_recursively, {}),
                conclusion = ls.insert_node(5, "<add conclusion here>"),
                last_cur_pos = ls.insert_node(0)
            }
        )
    ),
    -- tasks snippet
    ls.snippet('tasks',
        fmt("* [{check}] {task}{more_task}", {
            check = ls.choice_node(1, {ls.text_node(" "), ls.text_node("X"), ls.text_node("-")}),
            task  = ls.insert_node(2, "task"),
            more_task = ls.dynamic_node(3, add_tasks_recursively),
        })
   ),
    -- todays' tasks snippet
    ls.snippet('ttasks',
        fmt(
            [[
            # {date}
            * [{check}] {task}{more_task}
            ]], {
            date = ls.function_node(get_current_date),
            check = ls.choice_node(1, {ls.text_node(" "), ls.text_node("X"), ls.text_node("-")}),
            task  = ls.insert_node(2, "task"),
            more_task = ls.dynamic_node(3, add_tasks_recursively),
        })
   ),
})

