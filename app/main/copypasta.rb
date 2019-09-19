# Crystal: Copypasta


# Contains commands to add, remove, list copypastas and respond to their triggers.
module Bot::Copypasta
  extend Discordrb::Commands::CommandContainer
  extend Discordrb::EventContainer
  include Bot::Models

  extend Convenience
  include Constants

  # #praetorium channel ID
  PRAETORIUM_ID = 602783928318689291
  
  # Add pasta to database
  command :addpasta,
          description: 'Adds a copypasta to the database.',
          usage: '+addpasta <trigger>' do |event, *args|
    # Break unless user is me (Katie) and at least one argument given
    break unless event.user.id == MY_ID &&
                 args.any?

    # If trigger is already in database, respond to user and break
    if Pasta[trigger: args.join(' ').downcase]
      event.send_temp('This trigger already exists!', 5)
      break
    end

    pasta = Pasta.create(trigger: args.join(' ').downcase)

    # Prompt user for copypasta text and await response
    msg = event.respond '**What should the copypasta text be?**'
    await_event = event.message.await!(timeout: 30)

    # If prompt was answered add to database, save, delete messages and respond to user
    if await_event
      pasta.text = await_event.message.content
      pasta.save
      msg.delete
      await_event.message.delete
      event << "**Added copypasta with trigger `#{pasta.trigger}` to database.**"

    # Otherwise, destroy from database, delete messages and respond to user
    else
      pasta.destroy
      msg.delete
      event.send_temp('You took too long!', 5)
    end
  end

  # Respond to trigger with copypasta
  message do |event|
    # Skip if trigger is in #praetorium
    next if event.channel.id == PRAETORIUM_ID
    triggers = Pasta.map(:trigger)

    # Skip unless message contains one or more triggers
    next unless (selected_triggers = triggers.select { |t| event.message.content.downcase.include?(t) }).any?

    # Respond to all triggers found in message with copypasta
    selected_triggers.each do |trigger|
      event.respond Pasta[trigger: trigger].text
    end
  end

  # Display interactable list of pastas with their triggers
  command :listpasta,
          aliases: [:listpastas],
          description: 'Displays an interactable list of all copypastas with their triggers.',
          usage: '+listpasta' do |event|
    # If no pastas exist in database, respond to user and break
    if Pasta.all.empty?
      event.send_temp('There are no copypastas currently in the database!', 5)
      break
    end

    pastas = Pasta.all

    # Otherwise, send embed containing first listed copypasta
    msg = event.send_embed('Use the reaction buttons to navigate the list.') do |embed|
      pasta = pastas[0]
      embed.color = 0xFFD700
      embed.author = {
          name:     "Trigger: #{pasta.trigger}",
          icon_url: Bot::BOT.profile.avatar_url
      }
      embed.description = "``#{pasta.text}``"
      embed.footer = {text: 'Use +addpasta and +removepasta to add and remove copypastas.'}
    end

    # Add reaction controls to embed
    msg.reaction_controls(event.user, 0..(pastas.size - 1), 30) do |index|
      pasta = pastas[index]
      msg.edit(
          '',
          {
              color: 0xFFD700,
              author: {
                  name:     "Trigger: #{pasta.trigger}",
                  icon_url: Bot::BOT.profile.avatar_url
              },
              description: "``#{pasta.text}``",
              footer: {text: 'Use +addpasta and +removepasta to add and remove copypastas.'}
          }
      )
    end
  end

  # Remove pasta from database
  command :removepasta,
          description: 'Removes a copypasta from the database.',
          usage: '+removepasta <trigger>' do |event, *args|
    # Break unless user is me (Katie) and at least one argument given
    break unless event.user.id == MY_ID &&
                 args.any?

    # If pasta with given trigger is found in database, destroy it and respond to user
    if (pasta = Pasta[trigger: args.join(' ').downcase])
      pasta.destroy
      event << "**Removed copypasta with trigger `#{pasta.trigger}` from the database.**"

    # Otherwise, respond to user
    else
      event.send_temp('No copypasta with that trigger exists in the database!', 5)
    end
  end
end