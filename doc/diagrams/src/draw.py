from diagrams import Diagram
from diagrams.programming.language import Csharp
from diagrams.generic.device import Mobile
from diagrams.onprem.container import Docker

with Diagram("Ineration-1", show=False, outformat="png", filename="/output/iteration-1"):
    user = Mobile("User")
    app = Csharp("HelloWorld")

    user >> app

with Diagram("Ineration0", show=False, outformat="png", filename="/output/iteration0"):
    user = Mobile("User")
    app = Csharp("HelloWorld")
    container = Docker("Container")

    user >> container >> app