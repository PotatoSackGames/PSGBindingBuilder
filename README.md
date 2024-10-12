# PSGBindingBuilder

The file character_sheet.png comes from https://kaishido.itch.io/whale-island - check out his page for more free assets!


# Concept

Eons ago, Microsoft invented (loosely speaking) the model-view-viewmodel (or MVVM) UX design pattern. This pattern was widely disparaged as not a good replacement for model-view-controller, or MVC. But then it took off in popularity when binding frameworks started popping up, and even to this day, the MVVM pattern enjoys a solid reputation as a not-always-necessary but sometimes very useful tool for developers, especially UX developers/business app developers.

I'm now bringing this pattern to Godot, through the use of bindings.

The Binding Builder dock, which you'll typically see on the right side of the screen whenever you click on a node in the Godot editor if the plugin is added and turned on, will allow you to write out property paths which represent the bindings. This means you can, for instance, set a value on a node with a property that's on a resource that's well-buried in your set of models, or even on a singleton! You can also bind...signals. Meaning when you bind one, it adds whatever function you're pointing to with the binding, no matter where it shows up in the tree! The only limitation at the moment is that bindings cannot go to parents, or anywhere up the tree, unless you go to a singleton and then navigate from there.

These may be a bit fragile right now, as testing is slow when you're working alone on a project. But you should let me know what you think! Feel free to hit me up on Twitter: @KyleTheCoder, or support me on Patreon: patreon.com/KyleSzklenski.

See the demo to really grok the power of this framework.

# Oh the utilities!

This addon includes a couple very useful utility classes, useful even without the rest of the framework:

PSGObservableArray - an array that notifies anyone listening to the "changed" signal on it when the items in the array are changed.

PSGObservableValue - same deal, but for individual values. Hook up to the "changed" signal, and you'll be updated whenever the value changes!

# Mini-how-to

The easiest way to see how this works is to look at the test_control.tscn file if you're interested in using singletons for binding, and level_1.tscn if you're interested in using non-singletons for binding. The general approach is:

1. Add addon (if not already done)
2. Turn addon on (if not already on)
3. Find a node in your scene and tap on it.
4. For many default properties for that node, you'll see the Binding Builder dock popup on the right, and all signals and user-based properties on the script on that node, if any.
5. Tap on the LineEdit within the Binding Builder dock for the property you want to bind, and type in the path from that node where you want to target. For example, let's say you have a CharacterBody2D node with a script that has this property on it: 

var player = PlayerResource.new()

If you then tap on your CharacterBody2D, you'll see the "velocity" property under the Physics header on the right. Tap on the LineEdit to its right, and then write this in:

player.current_velocity

So long as your player has a current_velocity PSGObservableValue property, then whenever you update current_velocity.value, it automatically will update the velocity...no matter where you update current_velocity.value in the code. And you won't need to write any code to make that change in the player node itself!

To connect to an autoloaded singleton, start the binding with the name of the singleton.

# Demo

The demo game is sort of cool. You'll notice in the start scene, there are literally no scripts or signals attached anywhere. These aren't custom controls with some kind of hidden script on a child, no. And the Globals singleton literally just holds onto my player resource - there's no real logic in it the singleton. All of the logic exists in the resource, or in other places, and yet the UI is automatically updated when values change. If you go to the next scene, I control the velocity of my player in a state machine, which automatically updates in the player, without any real code tying them together.
