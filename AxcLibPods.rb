# 工程的全路径
project_path = '/Users/mc/Desktop/123/123.xcodeproj'    
# Axc库文件的路径
axc_lib_path = '/Users/mc/Desktop/未命名文件夹'
# 工程的新目录group名称
project_gorup_name = 'AxcLib'


# 参数处理以及设置准备工作
# 1、获取工程名
project_xcodeproj_name = project_path.split("/").last
project_name = project_xcodeproj_name.split(".").first
puts "设置工程名为：#{project_name}"

# 2、设置工作路径指向目标工程路径
project_path_array = project_path.split("/")# 切割
i = 0
first_pathStr = ''
project_path_array.each do |path|
  if i < project_path_array.length - 1 then
    first_pathStr.insert(first_pathStr.length,path)
    if i < project_path_array.length - 2 then
      first_pathStr.insert(first_pathStr.length,'/')
    end
  end
  i += 1
end

# 3、再拼接工程内部文件夹
first_pathStr = "#{first_pathStr}/#{project_name}"
Dir.chdir(first_pathStr)
puts "设置第一工作路径：#{Dir.getwd}"

# 4、构建工程文件目录
Dir.mkdir("#{project_gorup_name}")
puts "构建工程文件目录：#{project_gorup_name}"

# 5、设置第二工作路径
Dir.chdir(axc_lib_path)
puts "设置第二工作路径：#{Dir.getwd}"

# 6、获取文件集合
puts "正在获取文件..."
dirWorkPath = Dir.getwd
fileNameArray = Array.new
Dir.glob("*.m").each do |path|
  fileNameArray << "#{path}"
  puts "正在获取：#{path}"
end
Dir.glob("*.h").each do |path|
  fileNameArray << "#{path}"
  puts "正在获取：#{path}"
end

# 7、拷贝到工程文件
puts "正在拷贝到工程文件..."
require 'FileUtils'
axc_lib_path = "#{first_pathStr}/#{project_gorup_name}"
fileNameArray.each do |path|
  initialPath = "#{dirWorkPath}/#{path}"
  copyPath = "#{axc_lib_path}/#{path}"
  puts "正在将文件：#{initialPath} \n拷贝到工程：#{copyPath}"
  FileUtils.cp(initialPath,copyPath)      
end

# 8、开启工程
require 'Xcodeproj'
project = Xcodeproj::Project.open(project_path)
puts "打开工程成功！工程路径：#{project_path}"
target = project.targets.first  
group = project.main_group.find_subpath(File.join("#{project_name}","#{project_gorup_name}"), true)  
group.set_source_tree('SOURCE_ROOT')  
puts "获取target以及group成功！"

# 9、设置文件关联路径
puts "正在设置文件关联路径..."
fileNameArray.each do |path|
  file_ref = group.new_reference("#{axc_lib_path}/#{path}")  
  target.add_file_references([file_ref]) 
  puts "成功关联：#{path}"
end

# 10、保存
project.save  
puts "保存成功！"

