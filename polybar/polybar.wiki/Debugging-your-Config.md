This page is intended for both helping you debug issues you might have with your setup as well as to give you guidelines for what to do *before* opening a GitHub issue.

Whenever you encounter any problem when running polybar, you should apply the following steps to resolve your issue:

1. [Look at the Logs](#look-at-the-logs)
2. [Narrowing down the Issue](#narrowing-down-the-issue)
3. [Read the Documentation](#read-the-documentation)
4. [Ask for Help (if needed)](#ask-for-help-if-needed)

These will make sure that you have put in the work to track down the issue yourself and you may have already solved it
yourself after reaching step 3.

## Look at the Logs

By default polybar will output warnings and errors to "standard error" in the terminal it is run in. When you run into any
problems, your first step should always be to look at this output.

If you run polybar within a startup script, you might not see this output. In that case either run polybar directly from
the terminal to get its log output or redirect `stderr` in your startup script. If you start your bar like this:
```bash
polybar yourbar &
```
You can redirect polybar's `stderr` to some log file like this:
```bash
polybar yourbar 2>/path/to/logfile &
```

The warnings and errors in this output may give you some indications as to why polybar won't start or why certain 
modules are not displayed.

## Narrowing down the Issue

*If the step above already gave you a concrete location for where your problem is, you may skip this section. But come 
back to it if you open a new issue.*

Now we need to figure out where exactly the issue lies. This will make it easier for you to diagnose and fix the issue.
We do this with a so called *Minimal, Complete, and Verifiable example* ([mcve](https://stackoverflow.com/help/mcve)).
The idea is to create a setup where you still have the same problems but with
all unnecessary parts (especially modules) stripped out.
Note that you should not only make your config minimal but also your startup routine, preferably you should start a 
single polybar instance from the terminal.
The act of finding such a minimal example may already help you track down the source of your problem.

For example: if you start polybar as part of your WM's startup script and you have issues getting polybar to run, you may
try to run polybar directly from the terminal. If polybar starts from the terminal, you know that polybar's interaction 
with your WM startup routine is causing issues. If it doesn't start, you know the problem lies somewhere else. Without 
this information you might end up spending a lot of time searching in the wrong places.

Such an MCVE is not only helpful to you but also to people you might end up asking for help.
No one wants to see errors about your missing custom scripts when they help you debug issues with the pulseaudio module.
It also shows that you have invested time to try and fix the problem yourself
and because of that people may be more inclined to help you.

## Read the Documentation

The above should have given you a specific location where your bar has issues. The next step should be to read on the
[Wiki](https://github.com/polybar/polybar/wiki) about whatever component is not working. Most problems arise from incorrect
or incomplete configuration, so make sure you haven't missed some configuration option that could solve your issue.
Also consult the [Known Issues](https://github.com/polybar/polybar/wiki/Known-Issues) page and search through the 
[GitHub issues](https://github.com/polybar/polybar/issues?utf8=%E2%9C%93&q=is%3Aissue) for people that had the same issue.

## Ask for Help (if needed)

If you completed all the steps above and weren't able to fix the issue yourself, it may be time to ask someone for help.
On our [SUPPORT.md](https://github.com/polybar/polybar/blob/master/SUPPORT.md) page, you can find resources where you can 
ask for help. When you finally do reach out, make sure to include the MCVE that you created above as well as precise 
instructions on how to reproduce your issue.

It is possible that the issue you have experienced is not caused by an incorrect configuration but by an actual bug 
within polybar. If you are not a polybar expert, this determination is difficult to make. In general if you are not sure
that your issue is a problem within polybar itself, go through one of the places listed on our support page to get help.
If it's an actual bug, we will find out there and then you can open a new issue on GitHub.
