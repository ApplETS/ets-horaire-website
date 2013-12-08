module FlashHelper
  FLASH_TYPES = {
    success: 'alert-success',
    notice: 'alert-info',
    alert: 'alert-warning',
    error: 'alert-danger'
  }

  def flash_messages
    flash_messages = flash.keys.collect do |key|
      raise MissingFlashType.new("Associate the type #{key} to an alert class in FlashHelper.") unless FLASH_TYPES.has_key?(key)

      button = "<button class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times</button>"
      content = "#{button}#{flash[key]}"
      "<div class=\"alert #{FLASH_TYPES[key]} alert-dismissable\">#{content}</div>"
    end
    flash_messages.join
  end

  class MissingFlashType < Exception; end
end