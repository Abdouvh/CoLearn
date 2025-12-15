package co.learn.app.repositories;

import co.learn.app.entities.GroupResource;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

/**
 * Interface d'accès aux données pour les ressources de groupe.
 */
public interface GroupResourceRepository extends JpaRepository<GroupResource, Long> {
    List<GroupResource> findByGroup_Id(Long groupId);
}
