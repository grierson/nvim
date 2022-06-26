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
Group.new("Normal", colors.black, colors.back, nil)
Group.new('Function', colors.blue, colors.back, nil)
Group.new("Comment", colors.red, colors.back, nil)
Group.new('LineNr', colors.black, colors.grey, nil)
Group.new('IncSearch', colors.black, colors.grey, nil)
Group.new('Search', colors.black, colors.yellow, nil)
Group.new('Number', colors.purple, colors.back, nil)
Group.new('Keyword', colors.purple, colors.back, nil)
