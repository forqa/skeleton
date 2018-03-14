module Android

  def skeletoner
    dump = %x(adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml')
    page_source = %x(adb -s #{@udid} shell cat #{dump})
  end

end