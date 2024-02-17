from diagrams import Diagram
from diagrams.programming.language import Csharp
from diagrams.generic.device import Mobile
from diagrams.onprem.container import Docker

with Diagram("Iteration-1", show=False, outformat="png", filename="/output/iteration-1"):
    user = Mobile("User")
    app = Csharp("HelloWorld")

    user >> app

with Diagram("Iteration0", show=False, outformat="png", filename="/output/iteration0"):
    user = Mobile("User")
    app = Csharp("HelloWorld")
    container = Docker("Container")

    user >> container >> app

with Diagram("Iteration1", show=False, outformat="png", filename="/output/iteration1"):
    user = Mobile("User")
    hello_app = Csharp("HelloWorld")
    hello_container = Docker("HelloWorld Container")
    json_app = Csharp("HelloJsonWorld")
    json_container = Docker("HelloJsonWorld Container")

    user >> json_container >> json_app >> hello_container >> hello_app