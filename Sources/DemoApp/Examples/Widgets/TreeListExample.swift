import Adwaita

@MainActor
struct TreeListExample: DemoExample {
    let name = "Tree List"
    let id = "treelist"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Tree data — each node has a label and optional children
    struct TreeNode {
        let label: String
        let children: [TreeNode]
    }

    let tree: [TreeNode] = [
        TreeNode(label: "src", children: [
            TreeNode(label: "main.swift", children: []),
            TreeNode(label: "utils.swift", children: []),
        ]),
        TreeNode(label: "tests", children: [
            TreeNode(label: "test_main.swift", children: []),
        ]),
    ]

    // Flatten to index-based parallel arrays, then:
    let rootStore = ListStore()
    for _ in rootItems { rootStore.appendPlaceholder() }

    let treeModel = TreeListModel(
        root: rootStore,
        passthrough: false,    // wrap items in TreeListRow
        autoexpand: false
    ) { item in
        // Return a ListStore for children, or nil for leaves
        let childStore = ListStore()
        for _ in children { childStore.appendPlaceholder() }
        return childStore
    }

    // Factory with TreeExpander for indent + expand arrows
    let factory = SignalListItemFactory()
    factory.onSetup { listItem in
        let expander = TreeExpander()
        expander.child = Label("")
        listItem.child = expander
    }
    factory.onBind { listItem in
        let expander = listItem.child?.cast(TreeExpander.self)
        if let item = listItem.item {
            expander.setListRow(item.opaquePointer)
        }
    }

    let selection = SingleSelection(model: treeModel)
    let listView = ListView(model: selection, factory: factory)
    """

    func buildWidget() -> Widget {
        // Tree data structure
        struct TreeNode {
            let label: String
            let icon: String
            let children: [TreeNode]
        }

        // A project file tree
        let tree: [TreeNode] = [
            TreeNode(label: "Sources", icon: "folder-symbolic", children: [
                TreeNode(label: "App", icon: "folder-symbolic", children: [
                    TreeNode(label: "main.swift", icon: "text-x-generic-symbolic", children: []),
                    TreeNode(label: "AppDelegate.swift", icon: "text-x-generic-symbolic", children: []),
                    TreeNode(label: "Views", icon: "folder-symbolic", children: [
                        TreeNode(label: "ContentView.swift", icon: "text-x-generic-symbolic", children: []),
                        TreeNode(label: "SidebarView.swift", icon: "text-x-generic-symbolic", children: []),
                        TreeNode(label: "DetailView.swift", icon: "text-x-generic-symbolic", children: []),
                    ]),
                ]),
                TreeNode(label: "Library", icon: "folder-symbolic", children: [
                    TreeNode(label: "Networking.swift", icon: "text-x-generic-symbolic", children: []),
                    TreeNode(label: "Database.swift", icon: "text-x-generic-symbolic", children: []),
                ]),
            ]),
            TreeNode(label: "Tests", icon: "folder-symbolic", children: [
                TreeNode(label: "AppTests.swift", icon: "text-x-generic-symbolic", children: []),
                TreeNode(label: "LibraryTests.swift", icon: "text-x-generic-symbolic", children: []),
            ]),
            TreeNode(label: "Package.swift", icon: "text-x-generic-symbolic", children: []),
            TreeNode(label: "README.md", icon: "text-x-generic-symbolic", children: []),
            TreeNode(label: ".gitignore", icon: "text-x-generic-symbolic", children: []),
        ]

        // Flatten tree nodes into a lookup table keyed by index.
        // Each level gets its own contiguous range of indices.
        // We use a class to allow shared mutable state across closures.
        class TreeData {
            var nodes: [Int: TreeNode] = [:]
            var nextID: Int = 0

            /// Registers a list of nodes and returns their assigned indices.
            func register(_ nodes: [TreeNode]) -> [Int] {
                var indices: [Int] = []
                for node in nodes {
                    let id = nextID
                    nextID += 1
                    self.nodes[id] = node
                    indices.append(id)
                }
                return indices
            }
        }

        let data = TreeData()

        // Register root-level nodes
        let rootIndices = data.register(tree)

        // Root store — one placeholder per root item
        let rootStore = ListStore()
        for _ in rootIndices { rootStore.appendPlaceholder() }

        // Map from ListStore placeholder object pointer -> node index.
        // We populate this as stores are created.
        class PointerMap {
            var map: [UnsafeMutableRawPointer: Int] = [:]
        }
        let ptrMap = PointerMap()

        // Helper to populate a pointer map for a store's items
        func mapStoreItems(_ store: ListStore, to indices: [Int]) {
            for i in 0..<indices.count {
                guard let item = store.item(at: i) else { continue }
                ptrMap.map[item.pointer] = indices[i]
            }
        }

        mapStoreItems(rootStore, to: rootIndices)

        // TreeListModel — creates child stores lazily
        let treeModel = TreeListModel(
            root: rootStore,
            passthrough: false,     // items wrapped in GtkTreeListRow
            autoexpand: false       // user expands manually
        ) { [data, ptrMap] item in
            // Look up which node this item corresponds to
            guard let nodeIndex = ptrMap.map[item.pointer],
                  let node = data.nodes[nodeIndex],
                  !node.children.isEmpty else {
                return nil
            }

            // Register children and create a child store
            let childIndices = data.register(node.children)
            let childStore = ListStore()
            for _ in childIndices { childStore.appendPlaceholder() }
            mapStoreItems(childStore, to: childIndices)
            return childStore
        }

        // Factory — TreeExpander wrapping an icon + label
        let factory = SignalListItemFactory()
        factory.onSetup { listItem in
            let expander = TreeExpander()
            let box = Box(orientation: .horizontal, spacing: 6)
            let icon = Image()
            icon.pixelSize = 16
            let label = Label("")
            label.xalign = 0
            box.append(icon)
            box.append(label)
            expander.child = box
            listItem.child = expander
        }

        factory.onBind { [data, ptrMap] listItem in
            guard let child = listItem.child else { return }
            let expander = child.cast(TreeExpander.self)

            // Bind the TreeListRow so the expander can show expand/collapse arrows
            if let treeRowObj = listItem.item {
                expander.setListRow(treeRowObj)

                // The underlying item is inside the TreeListRow
                let treeRow = TreeListRow(borrowing: treeRowObj.pointer)
                if let underlyingItem = treeRow.item,
                   let nodeIndex = ptrMap.map[underlyingItem.pointer],
                   let node = data.nodes[nodeIndex],
                   let box = expander.child {
                    let icon = box.firstChild!.cast(Image.self)
                    let label = box.lastChild!.cast(Label.self)

                    label.text = node.label
                    icon.iconName = node.icon
                }
            }
        }

        // SingleSelection — allows selecting one node at a time
        let selection = SingleSelection(model: treeModel)
        let listView = ListView(model: selection, factory: factory)
        listView.showSeparators = true

        // Layout
        let outerBox = Box(orientation: .vertical, spacing: 12)
        outerBox.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Project File Tree"
        group.description = "TreeListModel with TreeExpander for expandable/collapsible tree nodes"

        let infoRow = ActionRow()
        infoRow.title = "Root items"
        let countLabel = Label("\(tree.count)")
        countLabel.addCSSClass("dim-label")
        countLabel.valign = .center
        infoRow.addSuffix(countLabel)
        group.add(infoRow)

        let depthRow = ActionRow()
        depthRow.title = "Max depth"
        depthRow.subtitle = "Sources > App > Views (3 levels deep)"
        group.add(depthRow)

        outerBox.append(group)

        // Tree view in a frame
        let frame = Frame()
        frame.child = listView
        listView.setSizeRequest(width: -1, height: 350)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}
