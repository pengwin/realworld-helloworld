from diagrams import Diagram
from diagrams.programming.language import Csharp
from diagrams.generic.device import Mobile

with Diagram("Ineration-1", show=False, outformat="png", filename="/output/iteration-1"):
    user = Mobile("User")
    app = Csharp("HelloWorld")

    user >> app