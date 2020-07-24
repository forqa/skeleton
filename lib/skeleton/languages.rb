class Language
  JAVA = 'java'.freeze
  RUBY = 'rb'.freeze
  PYTHON = 'py'.freeze
  JAVASCRIPT = 'js'.freeze
  SWIFT = 'swift'.freeze

  def java(camel_method_name:, locator_type:, locator_value:)
    <<~JAVA
      By #{camel_method_name} = MobileBy.#{locator_type[:java]}("#{locator_value}");

    JAVA
  end

  def ruby(snake_method_name:, locator_type:, locator_value:)
    <<~RUBY
      #{snake_method_name} = :#{locator_type[:ruby]}, "#{locator_value}"

    RUBY
  end

  def python(snake_method_name:, locator_type:, locator_value:)
    <<~PYTHON
      #{snake_method_name} = self.driver.#{locator_type[:python]}("#{locator_value})"

    PYTHON
  end

  def js(camel_method_name:, locator_type:, locator_value:)
    <<~JS
      let #{camel_method_name} = await driver.elements("#{locator_type[:javascript]}", "#{locator_value}");

    JS
  end

  def swift(camel_method_name:, element_type:, locator_value:, accessibility_id:)
    if accessibility_id
    <<~SWIFT
      let #{camel_method_name} = app.#{element_type}["#{locator_value}"]

    SWIFT
    else
      <<~SWIFT
      let #{camel_method_name} = app.#{element_type}.matching(
        NSPredicate(format: "#{locator_value}")
      ).element

      SWIFT
    end
  end

  def self.domain(format)
    case format
    when 'ruby', 'rb'
      RUBY
    when 'java'
      JAVA
    when 'javascript', 'js'
      JAVASCRIPT
    when 'python', 'py'
      PYTHON
    when 'swift'
      SWIFT
    else
      "I haven't this language format"
    end
  end

  def self.all
    %w[ruby java python javascript swift]
  end
end

class XCUIElement
  def self.types
    return {
        Other: "otherElements",
        Group: "groups",
        Window: "windows",
        Sheet: "sheets",
        Drawer: "drawers",
        Alert: "alerts",
        Dialog: "dialogs",
        Button: "buttons",
        RadioButton: "radioButtons",
        RadioGroup: "radioGroups",
        CheckBox: "checkBoxes",
        DisclosureTriangle: "disclosureTriangles",
        PopUpButton: "popUpButtons",
        ComboBox: "comboBoxes",
        MenuButton: "menuButtons",
        ToolbarButton: "toolbarButtons",
        Popover: "popovers",
        Keyboard: "keyboards",
        Key: "keys",
        NavigationBar: "navigationBars",
        TabBar: "tabBars",
        TabGroup: "tabGroups",
        Toolbar: "toolbars",
        StatusBar: "statusBars",
        Table: "tables",
        TableRow: "tableRows",
        TableColumn: "tableColumns",
        Outline: "outlines",
        OutlineRow: "outlineRows",
        Browser: "browsers",
        CollectionView: "collectionViews",
        Slider: "sliders",
        PageIndicator: "pageIndicators",
        ProgressIndicator: "progressIndicators",
        ActivityIndicator: "activityIndicators",
        SegmentedControl: "segmentedControls",
        Picker: "pickers",
        PickerWheel: "pickerWheels",
        Switch: "switches",
        Toggle: "toggles",
        Link: "links",
        Image: "images",
        Icon: "icons",
        SearchField: "searchFields",
        ScrollView: "scrollViews",
        ScrollBar: "scrollBars",
        StaticText: "staticTexts",
        TextField: "textFields",
        SecureTextField: "secureTextFields",
        DatePicker: "datePickers",
        TextView: "textViews",
        Menu: "menus",
        MenuItem: "menuItems",
        MenuBar: "menuBars",
        MenuBarItem: "menuBarItems",
        Map: "maps",
        WebView: "webViews",
        IncrementArrow: "incrementArrows",
        DecrementArrow: "decrementArrows",
        Timeline: "timelines",
        RatingIndicator: "ratingIndicators",
        ValueIndicator: "valueIndicators",
        SplitGroup: "splitGroups",
        Splitter: "splitters",
        RelevanceIndicator: "relevanceIndicators",
        ColorWell: "colorWells",
        HelpTag: "helpTags",
        Matte: "mattes",
        DockItem: "dockItems",
        Ruler: "rulers",
        RulerMarker: "rulerMarkers",
        Grid: "grids",
        LevelIndicator: "levelIndicators",
        Cell: "cells",
        LayoutArea: "layoutAreas",
        LayoutItem: "layoutItems",
        Handle: "handles",
        Stepper: "steppers",
        Tab: "tabs",
        TouchBar: "touchBars",
        StatusItem: "statusItems"
    }
  end
end
