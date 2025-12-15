package co.learn.app.repositories;

import co.learn.app.entities.GroupTask;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

/**
 * Interface d'accès aux données pour les tâches (Kanban) de groupe.
 */
public interface GroupTaskRepository extends JpaRepository<GroupTask, Long> {
    List<GroupTask> findByGroup_Id(Long groupId);
}
