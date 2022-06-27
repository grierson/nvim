local Color, colors, Group, groups, styles = require('colorbuddy').setup()

-- Use Color.new(<name>, <#rrggbb>) to create new colors
-- They can be accessed through colors.<name>
Color.new('back', '#F7F7F7')
Color.new('black', '#000000')
Color.new('red', '#AA3731')
Color.new('green', '#448C27')
Color.new('blue', '#325CC0')
Color.new('purple', '#7A3E9D')
Color.new('yellow', '#FFD863')
Color.new('lilac', '#BFDBFE')
Color.new('grey', '#CCCCCC')

-- Define highlights in terms of `colors` and `groups`
-- Comment
Group.new("Comment", colors.red, nil, nil)

-- Constant
Group.new('Constant', colors.black, nil, nil)
Group.new('Number', colors.purple, nil, nil)
Group.new('Boolean', colors.purple, nil, nil)
Group.new('String', colors.green, nil, nil)
Group.new('Character', colors.green, nil, nil)

-- Identifier
Group.new('Identifier', colors.black, nil, nil)
Group.new('Function', colors.blue, nil, nil)

-- Statement
Group.new('Statement', colors.black, nil, nil)
Group.new('Conditional', colors.black, nil, nil)
Group.new('Repeat', colors.black, nil, nil)
Group.new('Label', colors.black, nil, nil)
Group.new('Operator', colors.black, nil, nil)
Group.new('Keyword', colors.black, nil, nil)

-- PreProc
Group.new('PreProc', colors.black, nil, nil)

-- Type
Group.new('Type', colors.black, nil, nil)
Group.new('StorageClass', colors.black, nil, nil)
Group.new('Structure', colors.black, nil, nil)
Group.new('TypeDef', colors.black, nil, nil)

-- Special
Group.new('Special', colors.black, nil, nil)
Group.new('SpecialChar', colors.black, nil, nil)
Group.new('Tag', colors.black, nil, nil)

-- Underline
Group.new('Underlined', colors.blue, nil, styles.underline)

-- Error
Group.new('Error', colors.red, nil, styles.bold)

-- Todo
Group.new('Todo', colors.blue, nil, styles.bold)

-- Editor
Group.new("Normal", colors.black, colors.back, nil)
Group.new('LineNr', colors.black, colors.grey, nil)
Group.new('Search', colors.black, colors.yellow, nil)
Group.new('ColorColumn', colors.black, colors.grey, nil)

-- Clojure
Group.new('clojureTSKeyword', colors.black, nil, nil) -- def var
Group.new('clojureTSVariable', colors.blue, nil, nil) -- symbol name
Group.new('clojureTSSymbol', colors.purple, nil, nil) -- keyword
