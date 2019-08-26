# Crystal: Eval


# Contains a simple eval command.
module Bot::Eval
  extend Discordrb::Commands::CommandContainer

  include Constants

  command :eval,
          description: 'Evaluates the given Ruby code. Dangerous command, so only works for Katie!',
          usage: '+eval <Ruby code>' do |event|
    # Break unless user is me (Katie)
    break unless event.user.id == MY_ID

    code = event.message.content[6..-1]

    begin
      event << "**Returns:** `#{(eval code).inspect}`"
    rescue Exception => e
      event << <<~RESPONSE.strip
        **Error!** Message:
        ```
        #{e}```
      RESPONSE
    end
  end
end