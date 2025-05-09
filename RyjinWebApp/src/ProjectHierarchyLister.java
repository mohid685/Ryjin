import java.io.File;

public class ProjectHierarchyLister {

    public static void main(String[] args) {
        // You can change this path to any project folder
        String rootPath = args.length > 0 ? args[0] : "."; // "." means current directory
        File root = new File(rootPath);

        if (!root.exists() || !root.isDirectory()) {
            System.out.println("Invalid directory: " + rootPath);
            return;
        }

        System.out.println("Project hierarchy for: " + root.getAbsolutePath());
        printDirectoryTree(root, 0);
    }

    public static void printDirectoryTree(File folder, int indentLevel) {
        if (folder.isDirectory()) {
            printIndent(indentLevel);
            System.out.println("📁 " + folder.getName());
            File[] files = folder.listFiles();

            if (files != null) {
                for (File file : files) {
                    printDirectoryTree(file, indentLevel + 1);
                }
            }
        } else {
            printIndent(indentLevel);
            System.out.println("📄 " + folder.getName());
        }
    }

    private static void printIndent(int indentLevel) {
        for (int i = 0; i < indentLevel; i++) {
            System.out.print("   ");
        }
    }
}
