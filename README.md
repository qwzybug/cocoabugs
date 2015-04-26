## Welcome to CocoaBugs!

CocoaBugs is an Artificial Life experimentation framework for Mac OS X,
written in Objective-C.

![CocoaBugs screenshot](https://doormouse.org/misc/cocoabugs.jpg)

### INSTALLATION/USAGE

1. Open CocoaBugs/CocoaBugs.xcodeproj. Build-and-run.

2. Choose a plugin, edit its configuration, and start the simulation.

3. Use the toolbar buttons to step or run the simulation.

4. Use the "Options" panel to change simulation parameters, or export a
configuration file.

5. Build the "HeadlessBugs" target to do batch simulation of an exported
.cocoabugs file from the command-line.

```bash
HeadlessBugs run openboxes.cocoabugs --output run --steps 1000 --runs 10 \
  --sample mutationRate --min 0.2 --max 0.7
```
