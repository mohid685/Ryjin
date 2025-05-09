import java.io.File;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class ProjectHierarchyLister {

    // Define the allowed file extensions
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(
            Arrays.asList(".java", ".js", ".html", ".txt"));

    public static void main(String[] args) {
        // You can change this path to any project folder
        String rootPath = args.length > 0 ? args[0] : "."; // "." means current directory
        File root = new File(rootPath);

        if (!root.exists() || !root.isDirectory()) {
            System.out.println("Invalid directory: " + rootPath);
            return;
        }

        System.out.println("Project hierarchy for: " + root.getAbsolutePath());
        System.out.println("(Only showing src folder and root directory files with .java, .js, .html, .txt extensions)");

        // First print files in the root directory
        printRootFiles(root);

        // Then check for src folder
        File[] files = root.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory() && file.getName().equals("src")) {
                    printSrcDirectory(file, 0);
                    break;
                }
            }
        }
    }

    // Print only the files in the root directory that match our criteria
    private static void printRootFiles(File rootDir) {
        System.out.println("📁 " + rootDir.getName() + " (root)");

        File[] files = rootDir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (!file.isDirectory() && hasAllowedExtension(file.getName())) {
                    System.out.println("   📄 " + file.getName());
                }
            }
        }
    }

    // Print the src directory and its contents
    private static void printSrcDirectory(File srcDir, int indentLevel) {
        printIndent(indentLevel);
        System.out.println("📁 src");

        File[] files = srcDir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    // Skip git directories
                    if (file.getName().equals(".git") || file.getName().contains(".git")) {
                        continue;
                    }
                    printSrcSubdirectory(file, indentLevel + 1);
                } else if (hasAllowedExtension(file.getName())) {
                    printIndent(indentLevel + 1);
                    System.out.println("📄 " + file.getName());
                }
            }
        }
    }

    // Print src subdirectories and their relevant files
    private static void printSrcSubdirectory(File folder, int indentLevel) {
        printIndent(indentLevel);
        System.out.println("📁 " + folder.getName());

        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    // Skip git directories
                    if (file.getName().equals(".git") || file.getName().contains(".git")) {
                        continue;
                    }
                    printSrcSubdirectory(file, indentLevel + 1);
                } else if (hasAllowedExtension(file.getName())) {
                    printIndent(indentLevel + 1);
                    System.out.println("📄 " + file.getName());
                }
            }
        }
    }

    private static boolean hasAllowedExtension(String fileName) {
        String lowerCaseName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerCaseName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private static void printIndent(int indentLevel) {
        for (int i = 0; i < indentLevel; i++) {
            System.out.print("   ");
        }
    }
}