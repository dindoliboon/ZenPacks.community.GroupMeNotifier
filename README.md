ZenPacks.community.GroupMeNotifier
=============
Command suitable for sending Zenoss notification events to GroupMe.


Install
=======

Download the Python egg:
```bash
su zenoss -
wget https://github.com/dindoliboon/ZenPacks.community.GroupMeNotifier/releases/download/1.0.0/ZenPacks.community.GroupMeNotifier-1.0.0-py2.7.egg
zenpack --install ./ZenPacks.community.GroupMeNotifier-1.0.0-py2.7.egg
```

Or build from source:
```bash
su zenoss -
git clone https://github.com/dindoliboon/ZenPacks.community.GroupMeNotifier
cd ZenPacks.community.GroupMeNotifier
python setup.py bdist_egg
zenpack --install ./dist/ZenPacks.community.GroupMeNotifier-1.0.0-py2.7.egg
```


Configuration
=======
In Zenoss go to ``Events`` -> ``Triggers`` and create a trigger with the rules
for which you want to send events to GroupMe. Of course you can use an
existing trigger as well. For more detailed guide on triggers and
notifications see the [community documentation](http://wiki.zenoss.org/Notify_Me_of_Important_Events).

After you have a trigger you wish to use, go to ``notifications`` and create a
new notification. Set the ``Id`` to something memorable like `GroupMeErrors`
or similar and choose ``Command`` as the action.

After creating the notification, edit it. On the ``Notification`` tab
configure it as you see fit, but you are generally going to want to make sure
it is enabled, and that you have added the Trigger you created earlier. The
command does support clear messages, so go ahead and check that option if you
like.

You also need to provide the GroupMe BOT ID using the environment variable
``GROUPME_BOT_ID``

Now on the ``Content`` tab of the notification paste the following into the
``Command`` field:

```bash
export GROUPME_BOT_ID="=<YOUR GROUPME BOT ID>"
/opt/zenoss/ZenPacks/ZenPacks.community.GroupMeNotifier-1.0.0-py2.7.egg/ZenPacks/community/GroupMeNotifier/libexec/command.rb --device="${evt/device}" --info=${evt/summary} --component="${evt/component}" --severity=${evt/severity} --url="${urls/eventUrl}" --message=${evt/message}
```

And if you want to use the clear option, for the clear command:

```bash
export GROUPME_BOT_ID="=<YOUR GROUPME BOT ID>"
/opt/zenoss/ZenPacks/ZenPacks.community.GroupMeNotifier-1.0.0-py2.7.egg/ZenPacks/community/GroupMeNotifier/libexec/command.rb --device="${evt/device}" --info=${evt/summary} --component="${evt/component}" --severity=${evt/severity} --url="${urls/eventUrl}" --message=${evt/message} --cleared-by="${evt/clearid}" --clear
```


Additional Environment Variables
=======
In addition to ``GROUPME_BOT_ID`` which is required, you can also override
other options with the following optional environment variables:

- ``GROUPME_API_ENDPOINT`` - Allows you to override the API endpoint
- ``GROUPME_TIMEOUT`` - Defaults to 3 seconds, but if you have a slow
  connection to the GroupMe server, it can be increased or decreased.


Credits
=======
1. [zenoss-hipchat, written in Python for HipChat](https://github.com/carsongee/zenoss-hipchat), where this project was forked from.
2. [ZenPacks.Iwillfearnoevil.Domain](https://github.com/zenoss/ZenPacks.Iwillfearnoevil.Domain), base for creating the ZenPack.
