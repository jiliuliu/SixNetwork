module Fastlane
    module Actions
        module SharedValues
            RM_TAG_CUSTOM_VALUE = :RM_TAG_CUSTOM_VALUE
        end
        
        class RmTagAction < Action
            def self.run(params)
                # 这里写要执行的操作
                # params[:参数名称] 参数名称与下面self.available_options中的保持一致
                tagNum = params[:tagNum]
                rmLocalTag = params[:rmLocalTag]
                rmRemoteTag = params[:rmRemoteTag]
                
                command = []
                
                if rmLocalTag
                    # 删除本地标签
                    # git tag -d 标签名称
                    command << "git tag -d #{tagNum}"
                end
                if rmRemoteTag
                    # 删除远程标签
                    # git push origin :标签名称
                    command << "git push origin :#{tagNum}"
                    
                    
                    result = Actions.sh(command.join('&'))
                    UI.success("Successfully remove tag 🚀 ")
                    return result
                    
                end
            end
            
            #####################################################
            # @!group Documentation
            #####################################################
            
            def self.description
              # 对当前脚本的简单描述
              "删除tag"
            end

            def self.details
              # 对当前脚本的具体描述
              "使用当前action来删除本地和远程冲突的tag"
            end
            
            def self.available_options
                # Define all options your action supports.
                
                # Below a few examples
                [
                FastlaneCore::ConfigItem.new(key: :tagNum,
                                             description: "输入即将删除的tag",
                                             is_string: true),
                                             FastlaneCore::ConfigItem.new(key: :rmLocalTag,
                                                                          description: "是否删除本地tag",
                                                                          optional:true,
                                                                          is_string: false,
                                                                          default_value: true),
                                                                          FastlaneCore::ConfigItem.new(key: :rmRemoteTag,
                                                                                                       description: "是否删除远程tag",
                                                                                                       optional:true,
                                                                                                       is_string: false,
                                                                                                       default_value: true)
                                                                                                       ]
            end
            
            def self.authors
              # 作者姓名
              ["Six"]
            end
            
        end
    end
end
